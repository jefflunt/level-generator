require 'minitest/autorun'

class TestRoom < MiniTest::Spec
  def test_tokens
    assert_equal(
      Room::TOKENS,
      {
        -1 => '.',
        0 => ' ',
        1 => 'X'
      }
    )
  end

  # other tests can go here
end
