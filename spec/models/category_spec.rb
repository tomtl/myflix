require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.create(name: "Comedies")
    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    comedies = Category.create(name: "Comedies")
    southpark = Video.create(title: "Southpark", description: "Funny video!", category: comedies)
    futurama = Video.create(title: "Futurama", description: "Space travelling", category: comedies)
    expect(comedies.videos).to include(futurama, southpark)
  end
end
