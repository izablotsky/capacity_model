module FactoryInterface
  def report_for(name, *args)
    ReportsFactory.instance.for(name, *args).call
  end
end
