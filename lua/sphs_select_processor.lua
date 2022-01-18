local function processor(key_event, env)
    local RESULT_ACCEPTED = sphs_common.RESULT_ACCEPTED
    local RESULT_NOOP = sphs_common.RESULT_NOOP

    local SELECT2_KEY = "apostrophe"

    local context = env.engine.context

    if key_event:release() then
        return RESULT_NOOP
    end

    if key_event:repr() == SELECT2_KEY then
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
    else
        return RESULT_NOOP
    end
end

return { func = processor }
