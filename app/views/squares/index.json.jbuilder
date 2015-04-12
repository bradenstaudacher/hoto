json.array!(@squares) do |square|
  json.extract! square, :id
  json.url square_url(square, format: :json)
end
