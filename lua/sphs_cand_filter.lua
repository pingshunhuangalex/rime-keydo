local is_valid = sphs_common.is_valid
local starts_with = sphs_common.starts_with
local has_cn_char = sphs_common.has_cn_char
local force_commit = sphs_common.force_commit

local function filter(cand_list, env)
    local history_leader = env.history_leader
    local input = env.engine.context.input

    local should_auto_commit = true
    local auto_commit_cand = nil
    local prev_cand_text = nil
    local is_history = starts_with(input, history_leader)

    local function handle_auto_commit(cand)
        if auto_commit_cand then
            if should_auto_commit then
                should_auto_commit = false
            end

            return
        end

        auto_commit_cand = cand
    end

    for cand in cand_list:iter() do
        if not is_valid(cand.text) then
            goto continue
        end

        if is_history then
            if cand.text ~= prev_cand_text and has_cn_char(cand.text) then
                handle_auto_commit(cand)

                prev_cand_text = cand.text
            else
                goto continue
            end
        else
            handle_auto_commit(cand)
        end

        yield(cand)

        ::continue::
    end

    if should_auto_commit then
        if auto_commit_cand then
            force_commit(auto_commit_cand.text, env)
        elseif is_history then
            force_commit(input, env)
        end
    end
end

local function init(env)
    local config = env.engine.schema.config

    env.history_leader = config:get_string("repeat_history/input")
end

return { init = init, func = filter }
