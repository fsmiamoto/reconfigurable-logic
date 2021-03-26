defmodule LineFollowerTest do
  use ExUnit.Case
  doctest LineFollower

  test "should stop immediately if both sensors read false " do
    robot = %LineFollower{}

    assert LineFollower.move(robot, {false, false}) == %LineFollower{
             robot
             | left_motor: :stopped,
               right_motor: :stopped
           }
  end

  test "should move at full speed when both sensors read true" do
    robot = %LineFollower{}

    assert LineFollower.move(robot, {true, true}) == %LineFollower{
             robot
             | left_motor: :full_speed,
               right_motor: :full_speed
           }
  end

  test "should turn right when the left sensor reads false" do
    robot = %LineFollower{}

    assert LineFollower.move(robot, {false, true}) == %LineFollower{
             robot
             | left_motor: :half_speed,
               right_motor: :stopped
           }
  end

  test "should turn left when the right sensor reads false" do
    robot = %LineFollower{}

    assert LineFollower.move(robot, {true, false}) == %LineFollower{
             robot
             | left_motor: :stopped,
               right_motor: :half_speed
           }
  end
end
