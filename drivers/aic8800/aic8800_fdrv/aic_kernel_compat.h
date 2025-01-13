#ifndef _AIC_KERNEL_COMPAT_H_
#define _AIC_KERNEL_COMPAT_H_

#include <linux/version.h>

#if LINUX_VERSION_CODE >= KERNEL_VERSION(7, 0, 0)

/* Timer API renamed in kernel 7.x */
#define del_timer(t)           timer_delete(t)
#define del_timer_sync(t)      timer_delete_sync(t)
#define from_timer(var, callback, timer_fieldname) \
    timer_container_of(var, callback, timer_fieldname)

/* in_irq() removed in kernel 5.8+ */
#define in_irq()               in_hardirq()

/* cfg80211 API changes in kernel 7.x */
#define cfg80211_rx_spurious_frame(dev, addr, gfp) \
    cfg80211_rx_spurious_frame(dev, addr, 0, gfp)
#define cfg80211_rx_unexpected_4addr_frame(dev, addr, gfp) \
    cfg80211_rx_unexpected_4addr_frame(dev, addr, 0, gfp)
#define cfg80211_cac_event(netdev, chandef, event, gfp) \
    cfg80211_cac_event(netdev, chandef, event, gfp, 0)

#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(7, 0, 0) */

#endif /* _AIC_KERNEL_COMPAT_H_ */
