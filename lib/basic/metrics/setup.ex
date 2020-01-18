defmodule Basic.Metrics.Setup do
  @moduledoc false

  def setup do
    Basic.Metrics.CommandInstrumenter.setup()
    Basic.Web.MetricsExporter.setup()
  end

end
