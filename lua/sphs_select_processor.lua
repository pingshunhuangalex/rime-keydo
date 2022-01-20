local RESULT_ACCEPTED = sphs_common.RESULT_ACCEPTED
local RESULT_NOOP = sphs_common.RESULT_NOOP
local is_pressed = sphs_common.is_pressed

local SELECT2_KEY = "apostrophe"

local function processor(key_event, env)
    local context = env.engine.context

    if key_event:release() or not is_pressed(SELECT2_KEY, key_event) then
        return RESULT_NOOP
    end

    if context:select(1) then
        context:commit()

        return RESULT_ACCEPTED
    end

    if context:get_selected_candidate() then
        context:commit()
    else
        context:clear()
    end

    return RESULT_ACCEPTED
end

return { func = processor }
