#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif
/**
 * 设置桌面窗口的标题
 */
void setDesktopWindow(const char *title);
/**
 * 设置抽屉窗口的标题
 */
void setDrawerWindow(const char *title);
/**
 * 设置窗口动画起点（icon位置）
 */
void setWindowSource(const char *title, uint32_t x, uint32_t y);

/**
 * 应用设置（实际发送请求）
 */
int flush();
#ifdef __cplusplus
}
#endif