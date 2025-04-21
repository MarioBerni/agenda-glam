Directory structure:
└── marioberni-agenda-glam/
    ├── README.md
    ├── analysis_options.yaml
    ├── firebase.json
    ├── pubspec.lock
    ├── pubspec.yaml
    ├── .metadata
    ├── .windsurfrules
    ├── android/
    │   ├── build.gradle.kts
    │   ├── gradle.properties
    │   ├── settings.gradle.kts
    │   ├── .gitignore
    │   ├── app/
    │   │   ├── build.gradle.kts
    │   │   ├── google-services.json
    │   │   └── src/
    │   │       ├── debug/
    │   │       │   └── AndroidManifest.xml
    │   │       ├── main/
    │   │       │   ├── AndroidManifest.xml
    │   │       │   ├── kotlin/
    │   │       │   │   └── com/
    │   │       │   │       └── example/
    │   │       │   │           └── agenda_glam/
    │   │       │   │               └── MainActivity.kt
    │   │       │   └── res/
    │   │       │       ├── drawable/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── drawable-v21/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── mipmap-hdpi/
    │   │       │       ├── mipmap-mdpi/
    │   │       │       ├── mipmap-xhdpi/
    │   │       │       ├── mipmap-xxhdpi/
    │   │       │       ├── mipmap-xxxhdpi/
    │   │       │       ├── values/
    │   │       │       │   └── styles.xml
    │   │       │       └── values-night/
    │   │       │           └── styles.xml
    │   │       └── profile/
    │   │           └── AndroidManifest.xml
    │   └── gradle/
    │       └── wrapper/
    │           └── gradle-wrapper.properties
    ├── assets/
    │   └── images/
    ├── documentacion/
    │   ├── ESTRUCTURA.md
    │   ├── OLEADA-IMPLEMENTACIONES-1.md
    │   ├── OLEADA-IMPLEMENTACIONES-2.MD
    │   ├── OLEADA-IMPLEMENTACIONES-3.md
    │   ├── OLEADA-IMPLEMENTACIONES-4.md
    │   ├── OLEADA-IMPLEMENTACIONES-5.md
    │   ├── OLEADA-IMPLEMENTACIONES-6.md
    │   └── PROYECTO.md
    ├── ios/
    │   ├── .gitignore
    │   ├── Flutter/
    │   │   ├── AppFrameworkInfo.plist
    │   │   ├── Debug.xcconfig
    │   │   └── Release.xcconfig
    │   ├── Runner/
    │   │   ├── AppDelegate.swift
    │   │   ├── Info.plist
    │   │   ├── Runner-Bridging-Header.h
    │   │   ├── Assets.xcassets/
    │   │   │   ├── AppIcon.appiconset/
    │   │   │   │   └── Contents.json
    │   │   │   └── LaunchImage.imageset/
    │   │   │       ├── README.md
    │   │   │       └── Contents.json
    │   │   └── Base.lproj/
    │   │       ├── LaunchScreen.storyboard
    │   │       └── Main.storyboard
    │   ├── Runner.xcodeproj/
    │   │   ├── project.pbxproj
    │   │   ├── project.xcworkspace/
    │   │   │   ├── contents.xcworkspacedata
    │   │   │   └── xcshareddata/
    │   │   │       ├── IDEWorkspaceChecks.plist
    │   │   │       └── WorkspaceSettings.xcsettings
    │   │   └── xcshareddata/
    │   │       └── xcschemes/
    │   │           └── Runner.xcscheme
    │   ├── Runner.xcworkspace/
    │   │   ├── contents.xcworkspacedata
    │   │   └── xcshareddata/
    │   │       ├── IDEWorkspaceChecks.plist
    │   │       └── WorkspaceSettings.xcsettings
    │   └── RunnerTests/
    │       └── RunnerTests.swift
    ├── lib/
    │   ├── firebase_options.dart
    │   ├── main.dart
    │   ├── core/
    │   │   ├── enums/
    │   │   │   └── auth_method.dart
    │   │   └── theme/
    │   │       └── theme.dart
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── legal_consent_model.dart
    │   │   │   ├── legal_document_model.dart
    │   │   │   └── user_model.dart
    │   │   ├── repositories/
    │   │   │   ├── auth_repository.dart
    │   │   │   ├── legal_repository.dart
    │   │   │   └── user_repository.dart
    │   │   └── services/
    │   │       ├── auth_service.dart
    │   │       ├── legal_service.dart
    │   │       ├── terms_verification_service.dart
    │   │       └── auth/
    │   │           ├── auth.dart
    │   │           ├── auth_exception_handler.dart
    │   │           ├── auth_models.dart
    │   │           ├── auth_service.dart
    │   │           ├── auth_service_interface.dart
    │   │           ├── email_auth_service.dart
    │   │           ├── google_auth_service.dart
    │   │           └── phone_auth_service.dart
    │   ├── domain/
    │   │   └── repositories/
    │   │       ├── auth_repository_interface.dart
    │   │       └── user_repository_interface.dart
    │   └── presentation/
    │       ├── blocs/
    │       │   └── auth/
    │       │       ├── auth.dart
    │       │       ├── auth_bloc.dart
    │       │       ├── auth_event.dart
    │       │       └── auth_state.dart
    │       ├── pages/
    │       │   ├── home_page.dart
    │       │   ├── password_reset_page.dart
    │       │   ├── welcome_after_login_page.dart
    │       │   ├── welcome_page.dart
    │       │   ├── auth/
    │       │   │   ├── login_page.dart
    │       │   │   ├── phone_verification_page.dart
    │       │   │   ├── register_page.dart
    │       │   │   ├── verify_email_page.dart
    │       │   │   ├── login/
    │       │   │   │   ├── login_controller.dart
    │       │   │   │   ├── login_footer.dart
    │       │   │   │   ├── login_form.dart
    │       │   │   │   ├── login_header.dart
    │       │   │   │   ├── login_widgets.dart
    │       │   │   │   └── social_login_buttons.dart
    │       │   │   └── register/
    │       │   │       ├── register_controller.dart
    │       │   │       ├── register_footer.dart
    │       │   │       ├── register_form.dart
    │       │   │       ├── register_header.dart
    │       │   │       ├── register_widgets.dart
    │       │   │       └── social_register_buttons.dart
    │       │   ├── legal/
    │       │   │   ├── privacy_policy_page.dart
    │       │   │   ├── terms_conditions_page.dart
    │       │   │   └── terms_update_page.dart
    │       │   └── password_reset/
    │       │       ├── animated_container.dart
    │       │       ├── email_recovery_form.dart
    │       │       ├── password_reset_controller.dart
    │       │       ├── password_reset_footer.dart
    │       │       ├── password_reset_header.dart
    │       │       ├── password_reset_service.dart
    │       │       ├── password_reset_widgets.dart
    │       │       ├── phone_recovery_form.dart
    │       │       ├── reset_form.dart
    │       │       ├── success_message.dart
    │       │       └── verification_code_form.dart
    │       └── widgets/
    │           ├── app_router.dart
    │           ├── auth/
    │           │   ├── auth_widgets.dart
    │           │   ├── google_sign_in_button.dart
    │           │   ├── login_footer.dart
    │           │   ├── login_form.dart
    │           │   ├── login_header.dart
    │           │   ├── password_strength_indicator.dart
    │           │   ├── phone_input_field.dart
    │           │   ├── phone_register_form.dart
    │           │   ├── register_footer.dart
    │           │   ├── register_form.dart
    │           │   ├── register_header.dart
    │           │   └── sms_code_input.dart
    │           ├── common/
    │           │   ├── animated_background.dart
    │           │   ├── animated_form_container.dart
    │           │   └── custom_snackbar.dart
    │           ├── home/
    │           │   ├── app_drawer.dart
    │           │   └── user_profile_card.dart
    │           └── welcome/
    │               ├── action_buttons.dart
    │               ├── benefits_grid.dart
    │               ├── feature_carousel.dart
    │               ├── partners_carousel.dart
    │               ├── welcome_header.dart
    │               └── welcome_widgets.dart
    ├── linux/
    │   ├── CMakeLists.txt
    │   ├── .gitignore
    │   ├── flutter/
    │   │   ├── CMakeLists.txt
    │   │   ├── generated_plugin_registrant.cc
    │   │   ├── generated_plugin_registrant.h
    │   │   └── generated_plugins.cmake
    │   └── runner/
    │       ├── CMakeLists.txt
    │       ├── main.cc
    │       ├── my_application.cc
    │       └── my_application.h
    ├── macos/
    │   ├── .gitignore
    │   ├── Flutter/
    │   │   ├── Flutter-Debug.xcconfig
    │   │   ├── Flutter-Release.xcconfig
    │   │   └── GeneratedPluginRegistrant.swift
    │   ├── Runner/
    │   │   ├── AppDelegate.swift
    │   │   ├── DebugProfile.entitlements
    │   │   ├── Info.plist
    │   │   ├── MainFlutterWindow.swift
    │   │   ├── Release.entitlements
    │   │   ├── Assets.xcassets/
    │   │   │   └── AppIcon.appiconset/
    │   │   │       └── Contents.json
    │   │   ├── Base.lproj/
    │   │   │   └── MainMenu.xib
    │   │   └── Configs/
    │   │       ├── AppInfo.xcconfig
    │   │       ├── Debug.xcconfig
    │   │       ├── Release.xcconfig
    │   │       └── Warnings.xcconfig
    │   ├── Runner.xcodeproj/
    │   │   ├── project.pbxproj
    │   │   ├── project.xcworkspace/
    │   │   │   └── xcshareddata/
    │   │   │       └── IDEWorkspaceChecks.plist
    │   │   └── xcshareddata/
    │   │       └── xcschemes/
    │   │           └── Runner.xcscheme
    │   ├── Runner.xcworkspace/
    │   │   ├── contents.xcworkspacedata
    │   │   └── xcshareddata/
    │   │       └── IDEWorkspaceChecks.plist
    │   └── RunnerTests/
    │       └── RunnerTests.swift
    ├── test/
    │   └── widget_test.dart
    ├── web/
    │   ├── index.html
    │   ├── manifest.json
    │   └── icons/
    └── windows/
        ├── CMakeLists.txt
        ├── .gitignore
        ├── flutter/
        │   ├── CMakeLists.txt
        │   ├── generated_plugin_registrant.cc
        │   ├── generated_plugin_registrant.h
        │   └── generated_plugins.cmake
        └── runner/
            ├── CMakeLists.txt
            ├── flutter_window.cpp
            ├── flutter_window.h
            ├── main.cpp
            ├── resource.h
            ├── runner.exe.manifest
            ├── Runner.rc
            ├── utils.cpp
            ├── utils.h
            ├── win32_window.cpp
            ├── win32_window.h
            └── resources/
