defmodule Web.PhaseWinnersLive do
  use Phoenix.LiveView, layout: {Web.LayoutView, "live.html"}

  def render(assigns) do
    Phoenix.View.render(Web.PhaseView, "winners.html", assigns)
  end

  def mount(p, s, socket) do
    {:ok, challenge} = ChallengeGov.Challenges.get(p["cid"])
    {:ok, phase} = ChallengeGov.Phases.get(p["pid"])
    socket =
      socket
      |> assign(:phase, phase)
      |> assign(:challenge, challenge)
    |> assign(:winner_form, false)
    {:ok, socket}
  end

  def handle_event("add-winner", params, socket) do
    socket =
      socket
      |> assign(:winner_form, true)
    {:noreply, socket}
  end
end
