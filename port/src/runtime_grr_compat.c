/* Gravity Rush Remastered (CUSA01130): Offline compatibility runtime & system stubs.
 * Adapted from bloodborne_pc (runtime_compat.c) and shadPS4 HLE implementations.
 */
#define _GNU_SOURCE
#include "runtime.h"
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define ERR(n) ((int32_t)(UINT32_C(0x80020000) | (n)))
#define KERNEL_EINVAL ERR(22)
#define NP_SIGNED_OUT ((int32_t)0x80550006)
#define NET_CTL_NOT_CONNECTED ((int32_t)0x80412108)
#define NET_ENOTCONN ((int32_t)0x80410139)
#define HTTP_NETWORK ((int32_t)0x80431063)
#define RTC_INVALID ((int32_t)0x80B50002)
#define TROPHY_INVALID ((int32_t)0x80551604)

static ABI int32_t ok(void) { return 0; }
static ABI int32_t np_signed_out(void) { return NP_SIGNED_OUT; }
static ABI int32_t netctl_not_connected(void) { return NET_CTL_NOT_CONNECTED; }
static ABI int32_t rtc_invalid(void) { return RTC_INVALID; }
static ABI int32_t trophy_invalid(void) { return TROPHY_INVALID; }

/* Dialog states: 3 = finished/closed, 1 = cancelled */
enum { DIALOG_FINISHED = 3, DIALOG_RESULT_CANCELED = 1 };
static ABI int32_t dialog_finished(void) { return DIALOG_FINISHED; }
static ABI int32_t dialog_cancelled(int32_t *result) {
    if (result) *result = DIALOG_RESULT_CANCELED;
    return 0;
}

/* Save Data Dialog Result */
static ABI int32_t save_dialog_result(int32_t *result) {
    if (!result) return KERNEL_EINVAL;
    result[1] = 0;
    result[2] = 0;
    return 0;
}

/* PlayGo: report fully installed */
typedef struct { uint64_t progress, total; } PlayGoProgress;
static ABI int32_t playgo_progress(uint32_t handle, const uint16_t *chunks, uint32_t count, PlayGoProgress *out) {
    (void)handle; (void)chunks; (void)count;
    if (!out) return KERNEL_EINVAL;
    out->progress = out->total = 1;
    return 0;
}
static ABI int32_t playgo_eta(uint32_t handle, const uint16_t *chunks, uint32_t count, int64_t *eta) {
    (void)handle; (void)chunks; (void)count;
    if (eta) *eta = 0;
    return 0;
}
static ABI int32_t playgo_todo(uint32_t handle, void *list, uint32_t count, uint32_t *out_count) {
    (void)handle; (void)list; (void)count;
    if (out_count) *out_count = 0;
    return 0;
}

/* Direct memory release */
static ABI int32_t kernel_release_direct_mem(off_t start, size_t len) {
    (void)start; (void)len;
    return 0;
}

/* Kernel module info from addr stub */
static ABI int32_t kernel_get_module_info_from_addr(const void *addr, int flags, void *info) {
    (void)addr; (void)flags;
    if (!info) return KERNEL_EINVAL;
    memset(info, 0, 0x100);
    return 0;
}

static const RuntimeExport exports[] = {
    /* In-Game Message (libSceNpManager) */
    {"sceNpInGameMessageInitialize", np_signed_out},
    {"sceNpInGameMessageTerminate", ok},
    {"sceNpInGameMessageCreateHandle", np_signed_out},
    {"sceNpInGameMessageDeleteHandle", ok},
    {"sceNpInGameMessagePrepare", np_signed_out},
    {"sceNpInGameMessageSendData", np_signed_out},

    /* Game Custom Data Dialog */
    {"sceGameCustomDataDialogInitialize", ok},
    {"sceGameCustomDataDialogOpen", ok},
    {"sceGameCustomDataDialogUpdateStatus", dialog_finished},
    {"sceGameCustomDataDialogGetResult", dialog_cancelled},
    {"sceGameCustomDataDialogTerminate", ok},

    /* Invitation Dialog */
    {"sceInvitationDialogInitialize", ok},
    {"sceInvitationDialogOpen", ok},
    {"sceInvitationDialogUpdateStatus", dialog_finished},
    {"sceInvitationDialogGetResult", dialog_cancelled},
    {"sceInvitationDialogTerminate", ok},

    /* Facebook SNS Dialog */
    {"sceNpSnsFacebookDialogInitialize", ok},
    {"sceNpSnsFacebookDialogOpen", ok},
    {"sceNpSnsFacebookDialogUpdateStatus", dialog_finished},
    {"sceNpSnsFacebookDialogGetResult", dialog_cancelled},
    {"sceNpSnsFacebookDialogTerminate", ok},
    {"sceNpSnsFacebookCreateRequest", np_signed_out},
    {"sceNpSnsFacebookDeleteRequest", ok},
    {"sceNpSnsFacebookGetAccessToken", np_signed_out},

    /* Web Browser Dialog */
    {"sceWebBrowserDialogInitialize", ok},
    {"sceWebBrowserDialogOpen", ok},
    {"sceWebBrowserDialogUpdateStatus", dialog_finished},
    {"sceWebBrowserDialogTerminate", ok},

    /* Commerce Dialog */
    {"sceNpCommerceDialogGetResult", dialog_cancelled},

    /* Save Data Dialog */
    {"sceSaveDataDialogClose", ok},
    {"sceSaveDataDialogGetResult", save_dialog_result},
    {"sceSaveDataDialogProgressBarSetValue", ok},

    /* ScreenShot */
    {"sceScreenShotEnable", ok},
    {"sceScreenShotDisable", ok},
    {"sceScreenShotSetParam", ok},
    {"sceScreenShotSetOverlayImage", ok},

    /* PlayGo */
    {"scePlayGoGetProgress", playgo_progress},
    {"scePlayGoPrefetch", ok},
    {"scePlayGoClose", ok},
    {"scePlayGoTerminate", ok},
    {"scePlayGoGetEta", playgo_eta},
    {"scePlayGoGetToDoList", playgo_todo},

    /* Audio3D Flush */
    {"sceAudio3dPortFlush", ok},

    /* Font extras */
    {"sceFontSupportSystemFonts", ok},
    {"sceFontAttachDeviceCacheBuffer", ok},

    /* Kernel extras */
    {"sceKernelCheckedReleaseDirectMemory", kernel_release_direct_mem},
    {"sceKernelGetModuleInfoFromAddr", kernel_get_module_info_from_addr},

    /* RTC extras */
    {"sceRtcParseDateTime", rtc_invalid},
    {"sceRtcParseRFC3339", rtc_invalid},

    /* NetCtl */
    {"sceNetCtlInit", ok},
    {"sceNetCtlTerm", ok},
    {"sceNetCtlGetResult", netctl_not_connected},

    /* NpAuth */
    {"sceNpAuthCreateRequest", np_signed_out},

    /* NpTrophy extras */
    {"sceNpTrophyGetGameIcon", trophy_invalid},
    {"sceNpTrophyGetGroupIcon", trophy_invalid},
    {"sceNpTrophyGetGroupInfo", trophy_invalid},
    {"sceNpTrophyGetTrophyIcon", trophy_invalid},

    /* NpUtility */
    {"sceNpLookupCreateRequest", np_signed_out},
    {"sceNpBandwidthTestInitStart", np_signed_out},
    {"sceNpBandwidthTestGetStatus", np_signed_out},
    {"sceNpBandwidthTestShutdown", ok},
    {"sceNpWordFilterCreateTitleCtx", np_signed_out},
    {"sceNpWordFilterDeleteTitleCtx", ok},
    {"sceNpWordFilterCreateRequest", np_signed_out},
    {"sceNpWordFilterCreateAsyncRequest", np_signed_out},
    {"sceNpWordFilterDeleteRequest", ok},
    {"sceNpWordFilterAbortRequest", ok},
    {"sceNpWordFilterPollAsync", np_signed_out},
    {"sceNpWordFilterCensorComment", np_signed_out},
    {"sceNpWordFilterSanitizeComment", np_signed_out},

    /* NpMatching2 */
    {"sceNpMatching2SetUserInfo", np_signed_out},
    {"sceNpMatching2RegisterRoomMessageCallback", ok},
    {"sceNpMatching2GetUserInfoList", np_signed_out},
    {"sceNpMatching2SendRoomMessage", np_signed_out},
    {"sceNpMatching2SendRoomChatMessage", np_signed_out},
    {"sceNpMatching2GetRoomDataExternalList", np_signed_out},
    {"sceNpMatching2GetRoomDataInternal", np_signed_out},
    {"sceNpMatching2GetRoomMemberDataInternal", np_signed_out},
    {"sceNpMatching2SignalingGetConnectionInfo", np_signed_out},

    /* NpScore */
    {"sceNpScoreGetFriendsRanking", np_signed_out},
    {"sceNpScoreGetFriendsRankingAsync", np_signed_out},
    {"sceNpScoreGetRankingByNpId", np_signed_out},
    {"sceNpScoreGetRankingByNpIdAsync", np_signed_out},
    {"sceNpScoreGetRankingByRangeAsync", np_signed_out},
    {"sceNpScoreRecordScoreAsync", np_signed_out},
    {"sceNpScoreRecordGameDataAsync", np_signed_out},
    {"sceNpScoreGetGameDataAsync", np_signed_out},
    {"sceNpScorePollAsync", np_signed_out},

    /* NpTus */
    {"sceNpTusCreateNpTitleCtx", np_signed_out},
    {"sceNpTusDeleteNpTitleCtx", ok},
    {"sceNpTusCreateRequest", np_signed_out},
    {"sceNpTusDeleteRequest", ok},
    {"sceNpTssGetData", np_signed_out},
    {"sceNpTusAddAndGetVariable", np_signed_out},
    {"sceNpTusAddAndGetVariableVUser", np_signed_out},
    {"sceNpTusDeleteMultiSlotData", np_signed_out},
    {"sceNpTusDeleteMultiSlotDataVUser", np_signed_out},
    {"sceNpTusGetData", np_signed_out},
    {"sceNpTusGetDataVUser", np_signed_out},
    {"sceNpTusGetMultiSlotVariable", np_signed_out},
    {"sceNpTusGetMultiSlotVariableVUser", np_signed_out},
    {"sceNpTusSetData", np_signed_out},
    {"sceNpTusSetDataVUser", np_signed_out},
    {"sceNpTusSetMultiSlotVariable", np_signed_out},
    {"sceNpTusSetMultiSlotVariableVUser", np_signed_out},

    /* NpWebApi */
    {"sceNpWebApiCreateHandle", np_signed_out},
    {"sceNpWebApiDeleteHandle", ok},
    {"sceNpWebApiCreateServicePushEventFilter", np_signed_out},
    {"sceNpWebApiDeleteServicePushEventFilter", ok},
    {"sceNpWebApiRegisterServicePushEventCallback", np_signed_out},
    {"sceNpWebApiUnregisterServicePushEventCallback", ok},
    {"sceNpWebApiSendRequest2", np_signed_out},
};

uintptr_t runtime_grr_compat_resolve(const char *name) {
    if (!strcmp(name, "GFhVUpRmbHE#libSceNpManager")) return (uintptr_t)np_signed_out;
    if (!strcmp(name, "bMG3cVmUmuk#libSceNpManager")) return (uintptr_t)ok;
    if (!strcmp(name, "+anuSx2avHQ#libSceNpManager")) return (uintptr_t)ok;
    if (!strcmp(name, "s4UEa5iBJdc#libSceNpManager")) return (uintptr_t)np_signed_out;
    if (!strcmp(name, "Vh1bhUG6mSs#libSceNpManager")) return (uintptr_t)np_signed_out;
    if (!strcmp(name, "ON7Sf5XEMmI#libSceNpManager")) return (uintptr_t)np_signed_out;
    return RUNTIME_LOOKUP(exports, name);
}

void runtime_grr_compat_report(void) {
    /* report hook */
}
