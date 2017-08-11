defmodule Surgex.RPC.TransportError do
  @moduledoc """
  Describes an RPC call failure in the transport layer.
  """

  alias Surgex.RPC.HTTPAdapter

  defexception [:adapter, :context]

  def message(%__MODULE__{adapter: HTTPAdapter, context: status_code}) do
    "HTTP request failed with code #{status_code}"
  end
end
