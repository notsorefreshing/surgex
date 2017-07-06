defmodule Surgex.SentryTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  describe "init/0" do
    test "patch enabled" do
      Mix.Config.persist(surgex: [
        sentry_patch_enabled: true
      ])

      log_for_default_config = capture_log(fn ->
        Surgex.Sentry.init()
      end)

      version = Mix.Project.config[:version]

      assert log_for_default_config =~
        ~s{Patching Sentry config (environment: :test, release: "#{version}")}

      Mix.Config.persist(surgex: [
        sentry_patch_enabled: true,
        sentry_environment: "abc",
        sentry_release: "def",
      ])

      log_for_manual_config = capture_log(fn ->
        Surgex.Sentry.init()
      end)

      assert log_for_manual_config =~
        ~s{Patching Sentry config (environment: "abc", release: "def")}
    end
  end

  describe "scrub_params/1" do
    test "params with secrets" do
      assert Surgex.Sentry.scrub_params(%{
        params: %{
          "username" => "a",
          "password" => "secret",
          "deep_array" => [
            %{
              "username" => "b",
              "password" => "secret",
            },
            %{
              "username" => "c",
              "password" => "secret",
            }
          ],
          "deep_map" => %{
            "username" => "d",
            "password" => "secret",
          }
        }
      }) == %{
        "deep_array" => [
          %{
            "password" => "[Filtered]",
            "username" => "b"
          },
          %{
            "password" => "[Filtered]",
            "username" => "c"
          }
        ],
        "deep_map" => %{
          "password" => "[Filtered]",
          "username" => "d"
        },
        "password" => "[Filtered]",
        "username" => "a"
      }
    end
  end
end
