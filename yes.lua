while true do
    turtle.placeUp()
    turtle.suckUp()
    turtle.suck()
    turtle.suckDown()

    if turtle.detect() then
        turtle.turnLeft()
        turtle.turnLeft()
    end
    turtle.forward()
end