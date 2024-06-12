#pragma once

#include "../configuration_json_helper.hpp"
#include <pqrs/json.hpp>

namespace krbn {
namespace core_configuration {
namespace details {
class global_configuration final {
public:
  global_configuration(const global_configuration&) = delete;

  global_configuration(const nlohmann::json& json,
                       error_handling error_handling)
      : json_(json) {
    helper_values_.push_back_value<bool>("check_for_updates_on_startup",
                                         check_for_updates_on_startup_,
                                         true);
    helper_values_.push_back_value<bool>("show_in_menu_bar",
                                         show_in_menu_bar_,
                                         true);
    helper_values_.push_back_value<bool>("show_profile_name_in_menu_bar",
                                         show_profile_name_in_menu_bar_,
                                         false);
    helper_values_.push_back_value<bool>("enable_notification_window",
                                         enable_notification_window_,
                                         true);
    helper_values_.push_back_value<bool>("ask_for_confirmation_before_quitting",
                                         ask_for_confirmation_before_quitting_,
                                         true);
    helper_values_.push_back_value<bool>("unsafe_ui",
                                         unsafe_ui_,
                                         false);

    pqrs::json::requires_object(json, "json");

    helper_values_.update_value(json, error_handling);
  }

  nlohmann::json to_json(void) const {
    auto j = json_;

    helper_values_.update_json(j);

    return j;
  }

  bool get_check_for_updates_on_startup(void) const {
    return check_for_updates_on_startup_;
  }
  void set_check_for_updates_on_startup(bool value) {
    check_for_updates_on_startup_ = value;
  }

  bool get_show_in_menu_bar(void) const {
    return show_in_menu_bar_;
  }
  void set_show_in_menu_bar(bool value) {
    show_in_menu_bar_ = value;
  }

  bool get_show_profile_name_in_menu_bar(void) const {
    return show_profile_name_in_menu_bar_;
  }
  void set_show_profile_name_in_menu_bar(bool value) {
    show_profile_name_in_menu_bar_ = value;
  }

  bool get_enable_notification_window(void) const {
    return enable_notification_window_;
  }
  void set_enable_notification_window(bool value) {
    enable_notification_window_ = value;
  }

  bool get_ask_for_confirmation_before_quitting(void) const {
    return ask_for_confirmation_before_quitting_;
  }
  void set_ask_for_confirmation_before_quitting(bool value) {
    ask_for_confirmation_before_quitting_ = value;
  }

  bool get_unsafe_ui(void) const {
    return unsafe_ui_;
  }
  void set_unsafe_ui(bool value) {
    unsafe_ui_ = value;
  }

private:
  nlohmann::json json_;
  bool check_for_updates_on_startup_;
  bool show_in_menu_bar_;
  bool show_profile_name_in_menu_bar_;
  bool enable_notification_window_;
  bool ask_for_confirmation_before_quitting_;
  bool unsafe_ui_;
  configuration_json_helper::helper_values helper_values_;
};

inline void to_json(nlohmann::json& json, const global_configuration& global_configuration) {
  json = global_configuration.to_json();
}
} // namespace details
} // namespace core_configuration
} // namespace krbn
