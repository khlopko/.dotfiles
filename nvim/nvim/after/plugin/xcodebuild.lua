require("xcodebuild").setup({
      logs = {
        auto_open_on_success_tests = false,
        auto_open_on_failed_tests = true,
        auto_open_on_success_build = false,
        auto_open_on_failed_build = true,
        auto_focus = false,
        auto_close_on_app_launch = true,
      },
      code_coverage = {
        enabled = true,
      },
      commands = {
          extra_build_args = "ONLY_ACTIVE_ARCHS=YES ARCHS=x86_64",
          extra_test_args = "ONLY_ACTIVE_ARCHS=YES ARCHS=x86_64"
      }
    })

