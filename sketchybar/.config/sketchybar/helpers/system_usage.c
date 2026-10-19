#include <mach/mach.h>
#include <mach/mach_host.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>

static int cpu_ticks(host_cpu_load_info_data_t *ticks) {
    mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
    return host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)ticks, &count);
}
int main(void) {
    host_cpu_load_info_data_t before, after;
    if (cpu_ticks(&before) != KERN_SUCCESS) return 2;
    usleep(200000);
    if (cpu_ticks(&after) != KERN_SUCCESS) return 2;
    uint64_t total = 0, idle = 0;
    for (int i = 0; i < CPU_STATE_MAX; i++) {
        uint32_t delta = after.cpu_ticks[i] - before.cpu_ticks[i];
        total += delta;
        if (i == CPU_STATE_IDLE) idle = delta;
    }
    vm_statistics64_data_t vm;
    mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
    if (host_statistics64(mach_host_self(), HOST_VM_INFO64, (host_info64_t)&vm, &count) != KERN_SUCCESS)
        return 2;
    uint64_t physical = 0;
    size_t bytes = sizeof(physical);
    if (sysctlbyname("hw.memsize", &physical, &bytes, NULL, 0) != 0 || !physical) return 2;
    vm_size_t page_size = 0;
    if (host_page_size(mach_host_self(), &page_size) != KERN_SUCCESS) return 2;
    // Active + wired + physical compressor pages; excludes reclaimable inactive cache.
    uint64_t used_pages = (uint64_t)vm.active_count + vm.wire_count + vm.compressor_page_count;
    double memory = 100.0 * used_pages * page_size / physical;
    if (memory > 100) memory = 100;
    printf("%.0f %.0f\n", total ? 100.0 * (total - idle) / total : 0, memory);
    return 0;
}
