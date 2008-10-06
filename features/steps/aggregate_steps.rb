Given /"(\w+)" is signed up for "(\w+)"/ do |name, happening|
  Given %{I am logged out}
  And %{there is a "#{happening}" happening page with parts}
  When %{I view the "#{happening}" signup page}
  And %{I fill in personal info for "#{name}"}
  And %{I press "Sign up"}
end
