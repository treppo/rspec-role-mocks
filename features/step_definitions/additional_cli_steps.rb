Then /^the example(?:s)? should(?: all)? pass$/ do
  step %q{the output should contain "0 failures"}
  step %q{the exit status should be 0}
end

Then /^the example(?:s)? should(?: all)? fail$/ do
  step %q{the exit status should be 1}
  examples, failures = all_output.match(/(\d+) examples?, (\d+) failures?/).captures.map(&:to_i)

  expect(examples).to be > 0
  expect(examples).to eq(failures)
end
