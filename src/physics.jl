import HypergeometricFunctions: _₂F₁

struct Physics
    friction_coefficient::Float64
    Ff::Function
    Fg::Function
    height::Function
end

function create_physics(; friction_coefficient::Float64 = 0.1)::Physics
    # Define friction force as a function of velocity (y_dot)
    Ff = (y_dot::Real) -> -friction_coefficient * y_dot
    
    # Define gravitational force as a function of position (y)
    Fg = (y::Real) -> begin
        if y < 0
            # Linear approximation for y < 0
            0.05*(-2*y - 1)
        else
            # Non-linear approximation for y >= 0
            0.05*(-(1 + 5*y^2)^(-0.5) - (y^2)*(1 + 5*y^2)^(-3/2) - (y^4)/16)
        end
    end

    # Define height as a function of horizontal position (x)
    height = (x::Float64) -> begin
        if x < 0
            # Quadratic function for x < 0
            h = x^2 + x
        else
            # Hypergeometric function and polynomial for x >= 0
            h = x * _₂F₁(0.5,0.5,1.5, -5*x^2) + x^3 * _₂F₁(1.5, 1.5, 2.5, -5*x^2) / 3 + x^5 / 80
        end
        0.05*h
    end
    return Physics(friction_coefficient, Ff, Fg, height)
end