import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/preferences/preferences_keys.dart';
import 'package:flutter_starter_kit/utils/preferences/preferences_utils.dart';

class PreferencesManager {
  Future<bool> clearAllData() async {
    return await PreferencesUtils.clearData();
  }

  Future<bool> clearAllUserData() async {
    final String? locale = await getLocale();
    await PreferencesUtils.clearData();
    if (locale != null) await setLocale(locale);
    return true;
  }

  Future<void> setLogOut() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, false);
  }

  Future<bool> setLocale(String data) async {
    return await PreferencesUtils.setString(PreferencesKeys.lang.name, data);
  }

  Future<String?> getLocale() async {
    return await PreferencesUtils.getString(PreferencesKeys.lang.name);
  }

  Future<void> setLoggedIn() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, true);
  }

  Future<bool> isLoggedIn() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isLoggedIn.name);
  }

  Future<void> setGuestUser() async {
    await PreferencesUtils.setBool(PreferencesKeys.isAnonymousUser.name, true);
  }

  Future<bool> isGuestUser() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isAnonymousUser.name);
  }

  Future<void> setAccessToken(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.accessToken.name, data);
  }

  Future<String?> getAccessToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.accessToken.name);
  }

  Future<String?> getUserFullName() async {
    return await PreferencesUtils.getString(PreferencesKeys.userFullName.name);
  }

  Future<void> setUserFullNameData(String fullName) async {
    await PreferencesUtils.setString(
      PreferencesKeys.userFullName.name,
      fullName,
    );
  }

  Future<String?> getUserId() async {
    return await PreferencesUtils.getString(PreferencesKeys.userId.name);
  }

  Future<void> setUserIdData(String userId) async {
    await PreferencesUtils.setString(PreferencesKeys.userId.name, userId);
  }

  Future<String?> getUserPhoneNumber() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.userPhoneNumber.name,
    );
  }

  Future<void> setUserPhoneNumberData(String userPhoneNumber) async {
    await PreferencesUtils.setString(
      PreferencesKeys.userPhoneNumber.name,
      userPhoneNumber,
    );
  }

  Future<void> setUserInfo(
    String userId,
    String userPhoneNumber,
    String userFullName,
  ) async {
    await setUserIdData(userId);
    await setUserPhoneNumberData(userPhoneNumber);
    await setUserFullNameData(userFullName);
  }

  Future<bool> setMode(int data) async {
    return await PreferencesUtils.setInt(PreferencesKeys.mode.name, data);
  }

  Future<int?> getMode() async {
    return await PreferencesUtils.getInt(PreferencesKeys.mode.name);
  }

  Future<bool> setHaveAddress() async {
    return await PreferencesUtils.setBool(
      PreferencesKeys.haveAddress.name,
      true,
    );
  }

  Future<bool> isHaveAddress() async {
    return await PreferencesUtils.getBool(PreferencesKeys.haveAddress.name);
  }

  Future<bool> setMainAddressId(int data) async {
    return await PreferencesUtils.setInt(
      PreferencesKeys.mainAddressId.name,
      data,
    );
  }

  Future<int?> getMainAddressId() async {
    return await PreferencesUtils.getInt(PreferencesKeys.mainAddressId.name);
  }

  Future<bool> setMainAddressTag(int data) async {
    return await PreferencesUtils.setInt(
      PreferencesKeys.mainAddressTag.name,
      data,
    );
  }

  Future<int?> getMainAddressTag() async {
    return await PreferencesUtils.getInt(PreferencesKeys.mainAddressTag.name);
  }

  Future<bool> setMainAddressDetails(String data) async {
    return await PreferencesUtils.setString(
      PreferencesKeys.mainAddressName.name,
      data,
    );
  }

  Future<String?> getMainAddressDetails() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.mainAddressName.name,
    );
  }

  Future<bool> setAddressLat(String lat) async {
    return await PreferencesUtils.setString(
      PreferencesKeys.mainAddressLat.name,
      lat,
    );
  }

  Future<String?> getAddressLat() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.mainAddressLat.name,
    );
  }

  Future<bool> setAddressLng(String lng) async {
    return await PreferencesUtils.setString(
      PreferencesKeys.mainAddressLng.name,
      lng,
    );
  }

  Future<String?> getAddressLng() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.mainAddressLng.name,
    );
  }

  Future<void> clearAddressInfo() async {
    await PreferencesUtils.deleteKey(PreferencesKeys.mainAddressName.name);
    await PreferencesUtils.deleteKey(PreferencesKeys.mainAddressTag.name);
    await PreferencesUtils.deleteKey(PreferencesKeys.mainAddressId.name);
    await PreferencesUtils.deleteKey(PreferencesKeys.mainAddressLat.name);
    await PreferencesUtils.deleteKey(PreferencesKeys.mainAddressLng.name);
    await PreferencesUtils.deleteKey(PreferencesKeys.haveAddress.name);
  }

  Future<void> setMainAddressInfo(
    int mainAddressId,
    String mainAddressDetails,
    int mainAddressTag,
    String lat,
    String lng,
  ) async {
    await setMainAddressId(mainAddressId);
    await setMainAddressTag(mainAddressTag);
    await setMainAddressDetails(mainAddressDetails);
    await setAddressLat(lat);
    await setAddressLng(lng);
  }

  Future<void> setB2bState(bool state) async {
    await PreferencesUtils.setBool(PreferencesKeys.b2bCompleted.name, state);
  }

  Future<bool> getB2bState() async {
    return await PreferencesUtils.getBool(PreferencesKeys.b2bCompleted.name);
  }

  Future<bool> setThemeMode(ThemeMode mode) async {
    return PreferencesUtils.setString(
      PreferencesKeys.themeMode.name,
      mode.name,
    );
  }

  Future<ThemeMode> getThemeMode() async {
    final value = await PreferencesUtils.getString(
      PreferencesKeys.themeMode.name,
    );
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
