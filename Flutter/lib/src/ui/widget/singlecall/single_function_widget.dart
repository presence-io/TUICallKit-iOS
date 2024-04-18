import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';
import 'package:tencent_calls_uikit/src/i18n/i18n_utils.dart';
import 'package:tencent_calls_uikit/src/call_manager.dart';
import 'package:tencent_calls_uikit/src/call_state.dart';
import 'package:tencent_calls_uikit/src/ui/widget/common/extent_button.dart';
import 'package:tencent_calls_uikit/src/utils/permission.dart';
import 'package:tencent_calls_uikit/src/data/constants.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class SingleFunctionWidget {
  static Widget buildFunctionWidget(Function close) {
    if (TUICallStatus.waiting == CallState.instance.selfUser.callStatus) {
      if (TUICallRole.caller == CallState.instance.selfUser.callRole) {
        if (TUICallMediaType.audio == CallState.instance.mediaType) {
          return _buildAudioCallerWaitingAndAcceptedView(close);
        } else {
          return _buildVideoCallerWaitingView(close);
        }
      } else {
        return _buildAudioAndVideoCalleeWaitingView(close);
      }
    } else if (TUICallStatus.accept == CallState.instance.selfUser.callStatus) {
      if (TUICallMediaType.audio == CallState.instance.mediaType) {
        return _buildAudioCallerWaitingAndAcceptedView(close);
      } else {
        return _buildVideoCallerAndCalleeAcceptedView(close);
      }
    } else {
      return Container();
    }
  }

  static Widget _buildAudioCallerWaitingAndAcceptedView(Function close) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ExtendButton(
          imgUrl: CallState.instance.isMicrophoneMute ? "assets/images/mute_on.png" : "assets/images/mute.png",
          tips: CallState.instance.isMicrophoneMute ? CallKit_t("麦克风已关闭") : CallKit_t("麦克风已开启"),
          textColor: _getTextColor(),
          imgHeight: 60,
          onTap: () {
            _handleSwitchMic();
          },
        ),
        ExtendButton(
          imgUrl: "assets/images/hangup.png",
          tips: CallKit_t("挂断"),
          textColor: _getTextColor(),
          imgHeight: 60,
          onTap: () {
            _handleHangUp(close);
          },
        ),
        ExtendButton(
          imgUrl: CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
              ? "assets/images/handsfree_on.png"
              : "assets/images/handsfree.png",
          tips: CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
              ? CallKit_t("扬声器已开启")
              : CallKit_t("扬声器已关闭"),
          imgHeight: 60,
          textColor: _getTextColor(),
          onTap: () {
            _handleSwitchAudioDevice();
          },
        ),
      ],
    );
  }

  static Widget _buildVideoCallerWaitingView(Function close) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(
            width: 100,
          ),
          ExtendButton(
            imgUrl: "assets/images/hangup.png",
            tips: CallKit_t("挂断"),
            textColor: _getTextColor(),
            imgHeight: 60,
            onTap: () {
              _handleHangUp(close);
            },
          ),
          ExtendButton(
            imgUrl: "assets/images/switch_camera.png",
            tips: CallKit_t(" "),
            textColor: _getTextColor(),
            imgHeight: 28,
            onTap: () {
              _handleSwitchCamera();
            },
          ),
        ]),
      ],
    );
  }

  static Widget _buildVideoCallerAndCalleeAcceptedView(Function close) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExtendButton(
              imgUrl: CallState.instance.isMicrophoneMute ? "assets/images/mute_on.png" : "assets/images/mute.png",
              tips: CallState.instance.isMicrophoneMute ? CallKit_t("麦克风已关闭") : CallKit_t("麦克风已开启"),
              textColor: _getTextColor(),
              imgHeight: 60,
              onTap: () {
                _handleSwitchMic();
              },
            ),
            ExtendButton(
              imgUrl: CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
                  ? "assets/images/handsfree_on.png"
                  : "assets/images/handsfree.png",
              tips: CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
                  ? CallKit_t("扬声器已开启")
                  : CallKit_t("扬声器已关闭"),
              textColor: _getTextColor(),
              imgHeight: 60,
              onTap: () {
                _handleSwitchAudioDevice();
              },
            ),
            ExtendButton(
              imgUrl: CallState.instance.isCameraOpen ? "assets/images/camera_on.png" : "assets/images/camera_off.png",
              tips: CallState.instance.isCameraOpen ? CallKit_t("摄像头已开启") : CallKit_t("摄像头已关闭"),
              textColor: _getTextColor(),
              imgHeight: 60,
              onTap: () {
                _handleOpenCloseCamera();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(
            width: 100,
          ),
          ExtendButton(
            imgUrl: "assets/images/hangup.png",
            tips: '',
            textColor: _getTextColor(),
            imgHeight: 60,
            onTap: () {
              _handleHangUp(close);
            },
          ),
          CallState.instance.isCameraOpen
          ? ExtendButton(
            imgUrl: "assets/images/switch_camera.png",
            tips: CallKit_t(" "),
            textColor: _getTextColor(),
            imgHeight: 28,
            onTap: () {
              _handleSwitchCamera();
            },
          )
          : const SizedBox(
            width: 100,
          ),
        ]),
      ],
    );
  }

  static Widget _buildAudioAndVideoCalleeWaitingView(Function close) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExtendButton(
              imgUrl: "assets/images/hangup.png",
              tips: CallKit_t("挂断"),
              textColor: _getTextColor(),
              imgHeight: 60,
              onTap: () {
                _handleReject(close);
              },
            ),
            ExtendButton(
              imgUrl: "assets/images/dialing.png",
              tips: CallKit_t("接听"),
              textColor: _getTextColor(),
              imgHeight: 60,
              onTap: () {
                _handleAccept();
              },
            ),
          ],
        )
      ],
    );
  }

  static _handleSwitchMic() async {
    if (CallState.instance.isMicrophoneMute) {
      CallState.instance.isMicrophoneMute = false;
      await CallManager.instance.openMicrophone();
    } else {
      CallState.instance.isMicrophoneMute = true;
      await CallManager.instance.closeMicrophone();
    }
    TUICore.instance.notifyEvent(setStateEvent);
  }

  static _handleSwitchAudioDevice() async {
    if (CallState.instance.audioDevice == TUIAudioPlaybackDevice.earpiece) {
      CallState.instance.audioDevice = TUIAudioPlaybackDevice.speakerphone;
    } else {
      CallState.instance.audioDevice = TUIAudioPlaybackDevice.earpiece;
    }
    await CallManager.instance.selectAudioPlaybackDevice(CallState.instance.audioDevice);
    TUICore.instance.notifyEvent(setStateEvent);
  }

  static _handleHangUp(Function close) async {
    await CallManager.instance.hangup();
    close();
  }

  static _handleReject(Function close) async {
    await CallManager.instance.reject();
    close();
  }

  static _handleAccept() async {
    PermissionResult permissionRequestResult = PermissionResult.requesting;
    if (Platform.isAndroid) {
      permissionRequestResult = await Permission.request(CallState.instance.mediaType);
    }
    if (permissionRequestResult == PermissionResult.granted || Platform.isIOS) {
      await CallManager.instance.accept();
      CallState.instance.selfUser.callStatus = TUICallStatus.accept;
    } else {
      CallManager.instance.showToast(CallKit_t("新通话呼入，但因权限不足，无法接听。请确认摄像头/麦克风权限已开启。"));
    }
    TUICore.instance.notifyEvent(setStateEvent);
  }

  static void _handleOpenCloseCamera() async {
    CallState.instance.isCameraOpen = !CallState.instance.isCameraOpen;
    if (CallState.instance.isCameraOpen) {
      await CallManager.instance.openCamera(CallState.instance.camera, CallState.instance.selfUser.viewID);
    } else {
      await CallManager.instance.closeCamera();
    }
    TUICore.instance.notifyEvent(setStateEvent);
  }

  static void _handleSwitchCamera() async {
    if (TUICamera.front == CallState.instance.camera) {
      CallState.instance.camera = TUICamera.back;
    } else {
      CallState.instance.camera = TUICamera.front;
    }
    await CallManager.instance.switchCamera(CallState.instance.camera);
    TUICore.instance.notifyEvent(setStateEvent);
  }

  static Color _getTextColor() {
    return  Colors.white;
  }
}
