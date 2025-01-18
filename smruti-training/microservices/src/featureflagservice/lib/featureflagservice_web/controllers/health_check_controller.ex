defmodule FeatureflagserviceWeb.HealthCheckController do
  use FeatureflagserviceWeb, :controller

  def index(conn, _params) do
    # Respond with HTTP 200 OK to indicate the service is healthy
    send_resp(conn, 200, "OK")
  end
end
