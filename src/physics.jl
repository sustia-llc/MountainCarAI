function create_physics(; engine_force_limit = 0.04, friction_coefficient = 0.1)
    Fa = (a::Real) -> engine_force_limit * tanh(a) 
    Ff = (y_dot::Real) -> -friction_coefficient * y_dot 
    Fg = (y::Real) -> begin
        if y < 0
            0.05*(-2*y - 1)
        else
            0.05*(-(1 + 5*y^2)^(-0.5) - (y^2)*(1 + 5*y^2)^(-3/2) - (y^4)/16)
        end
    end
    height = (x::Float64) -> begin
        if x < 0
            h = x^2 + x
        else
            h = x * _₂F₁(0.5,0.5,1.5, -5*x^2) + x^3 * _₂F₁(1.5, 1.5, 2.5, -5*x^2) / 3 + x^5 / 80
        end
        return 0.05*h
    end
    return (Fa, Ff, Fg, height)
end

function create_world(; Fg, Ff, Fa, initial_position = -0.5, initial_velocity = 0.0)
    y_t_min = initial_position
    y_dot_t_min = initial_velocity
    y_t = y_t_min
    y_dot_t = y_dot_t_min
    
    execute = (a_t::Float64) -> begin
        y_dot_t = y_dot_t_min + Fg(y_t_min) + Ff(y_dot_t_min) + Fa(a_t)
        y_t = y_t_min + y_dot_t
        y_t_min = y_t
        y_dot_t_min = y_dot_t
    end
    
    observe = () -> [y_t, y_dot_t]
        
    return (execute, observe)
end