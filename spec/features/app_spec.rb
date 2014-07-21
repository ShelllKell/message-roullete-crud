require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end
end

# feature "edit" do
#   scenario "there's a form field with text inside of it" do
#     visit "/messages/edit/:id"
#
#     expect(page).to have_content("Edit Message")
#
#     fill_in "Message", :with => "Hey Everyone"
#     e






  end
end




