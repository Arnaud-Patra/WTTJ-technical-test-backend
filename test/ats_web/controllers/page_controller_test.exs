defmodule AtsWeb.PageControllerTest do
  use AtsWeb.ConnCase

  @tag :skip
  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
