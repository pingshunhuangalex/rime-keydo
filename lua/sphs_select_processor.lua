local select_trigger_2nd = "apostrophe"

local function sphs_select_processor(key_event, env)
    local context = env.engine.context

    if key_event:release() or key_event:repr() ~= select_trigger_2nd then
        return 2
    end

    if context:select(1) then
        context:commit()

        return 1
    end

    if not context:get_selected_candidate() then
        context:clear()
    else
        context:commit()
    end

    return 2
end

return { func = sphs_select_processor }
