defmodule LineFollower do
  @moduledoc """
  This module simulates a line follower robot
  """

  @type speed :: :stopped | :half_speed | :full_speed

  @type escaped :: :left | :right

  @type t :: %LineFollower{
          left_motor: speed,
          right_motor: speed,
          escaped: escaped
        }

  defstruct left_motor: 0,
            right_motor: 0,
            escaped: :left

  @type sensor_reading :: {boolean(), boolean()}

  @spec move(LineFollower.t(), sensor_reading()) :: LineFollower.t()

  def move(robot, {true, true}) do
    %LineFollower{robot | left_motor: :full_speed, right_motor: :full_speed}
  end

  def move(robot, {false, true}) do
    %LineFollower{robot | left_motor: :half_speed, right_motor: :stopped}
  end

  def move(robot, {true, false}) do
    %LineFollower{robot | left_motor: :stopped, right_motor: :half_speed}
  end

  def move(%{escaped: :left} = robot, {false, false}) do
    %LineFollower{robot | left_motor: :half_speed, right_motor: :stopped}
  end

  def move(%{escaped: :right} = robot, {false, false}) do
    %LineFollower{robot | left_motor: :stopped, right_motor: :half_speed}
  end

  def move(_robot, _sensors) do
    %LineFollower{}
  end
end
