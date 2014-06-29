require 'spec_helper'

describe AppSetting do

  it { should respond_to(:num_docs_friday) }
  it { should respond_to(:max_num_full_days) }
  it { should respond_to(:max_initial_shifts) }
  it { should respond_to(:friday_full_shift) }

  it "returns all values" do
    app_setting = AppSetting.create([
      {num_docs_friday: 1,
        max_num_full_days: 2,
        max_initial_shifts: 5,
        friday_full_shift: true}
      ])
    expect(AppSetting.first.num_docs_friday).to eq 1
    expect(AppSetting.first.max_num_full_days).to eq 2
    expect(AppSetting.first.max_initial_shifts).to eq 5
    expect(AppSetting.first.friday_full_shift).to eq true
  end
end
