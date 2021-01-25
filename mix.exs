defmodule Surgex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :surgex,
      version: "3.2.8",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      escript: [main_module: Surgex.Command],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      name: "Surgex",
      description: "All Things Elixir @ Surge Ventures Inc, the creators of Shedul",
      source_url: "https://github.com/surgeventures/surgex",
      homepage_url: "https://github.com/surgeventures/surgex",
      docs: [main: "readme", logo: "logo.png", extras: ["README.md", "CHANGELOG.md"]],
      dialyzer: [
        plt_add_apps: [:mix],
        list_unused_filters: true,
        remove_defaults: [:unknown]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Karol Słuszniak"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/surgeventures/surgex",
        "Shedul" => "https://www.shedul.com"
      },
      files: ~w(mix.exs lib LICENSE.md README.md CHANGELOG.md)
    ]
  end

  def application do
    [mod: {Surgex.Application, []}, extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      check: check_alias(),
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.8.1", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:ex_machina, "~> 2.3", only: :test},
      {:excoveralls, "~> 0.7", only: :test},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:mock, "~> 0.2.1", only: :test},
      {:postgrex, ">= 0.0.0", only: :test}
    ] ++ optional_deps()
  end

  defp optional_deps do
    [
      {:appsignal, "~> 1.8"},
      {:confix, "~> 0.4"},
      {:ecto_sql, "~> 3.0"},
      {:jabbax, "~> 0.1"},
      {:plug, "~> 1.7"}
    ]
    |> Enum.map(&merge_dep_flags(&1, optional: true))
  end

  defp check_alias do
    [
      "test",
      "credo --strict",
      "dialyzer --halt-exit-status"
    ]
  end

  defp merge_dep_flags({pkg, flg}, flags) when is_list(flg), do: {pkg, Keyword.merge(flg, flags)}
  defp merge_dep_flags({pkg, ver}, flags), do: {pkg, ver, flags}
  defp merge_dep_flags({pkg, ver, flg}, flags), do: {pkg, ver, Keyword.merge(flg, flags)}
end
