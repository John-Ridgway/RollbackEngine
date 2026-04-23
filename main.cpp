#include <SDL3/SDL.h>
#include <SDL3/SDL_vulkan.h>

#include <vulkan/vulkan.h>

#include <vector>
#include <iostream>
#include <stdexcept>

class VulkanApp
{
public:
    void run()
    {
        initSDL();
        initVulkan();
        mainLoop();
        cleanup();
    }

private:
    SDL_Window *window = nullptr;
    VkInstance instance = VK_NULL_HANDLE;
    VkSurfaceKHR surface = VK_NULL_HANDLE;

    void initSDL()
    {
        if (!SDL_Init(SDL_INIT_VIDEO))
        {
            throw std::runtime_error("Failed to initialize SDL3");
        }

        window = SDL_CreateWindow(
            "Rollback Engine",
            800, 600,
            SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE);

        if (!window)
        {
            throw std::runtime_error("Failed to create SDL window");
        }
    }

    void initVulkan()
    {
        createInstance();
        createSurface();
    }

    void createInstance()
    {
        // Get required extensions from SDL
        unsigned int extCount = 0;
        const char *const *sdlExtensions =
            SDL_Vulkan_GetInstanceExtensions(&extCount);

        if (!sdlExtensions)
        {
            throw std::runtime_error("Failed to get Vulkan extensions from SDL");
        }

        std::vector<const char *> extensions(sdlExtensions, sdlExtensions + extCount);

        VkApplicationInfo appInfo{};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = "SDL3 Vulkan App";
        appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.pEngineName = "Rollback Engine";
        appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.apiVersion = VK_API_VERSION_1_2;

        VkInstanceCreateInfo createInfo{};
        createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        createInfo.pApplicationInfo = &appInfo;
        createInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        createInfo.ppEnabledExtensionNames = extensions.data();

        if (vkCreateInstance(&createInfo, nullptr, &instance) != VK_SUCCESS)
        {
            throw std::runtime_error("Failed to create Vulkan instance");
        }
    }

    void createSurface()
    {
        if (!SDL_Vulkan_CreateSurface(window, instance, nullptr, &surface))
        {
            throw std::runtime_error("Failed to create Vulkan surface");
        }
    }

    void mainLoop()
    {
        bool running = true;
        SDL_Event event;

        while (running)
        {
            while (SDL_PollEvent(&event))
            {
                if (event.type == SDL_EVENT_QUIT)
                {
                    running = false;
                }
            }

            SDL_Delay(16);
        }
    }

    void cleanup()
    {
        if (surface != VK_NULL_HANDLE)
        {
            vkDestroySurfaceKHR(instance, surface, nullptr);
        }

        if (instance != VK_NULL_HANDLE)
        {
            vkDestroyInstance(instance, nullptr);
        }

        if (window)
        {
            SDL_DestroyWindow(window);
        }

        SDL_Quit();
    }
};

int main()
{
    try
    {
        VulkanApp app;
        app.run();
    }
    catch (const std::exception &e)
    {
        std::cerr << "Error: " << e.what() << std::endl;
        return -1;
    }

    return 0;
}