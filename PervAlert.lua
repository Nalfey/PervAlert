-- PervAlert: An addon that responds to examination messages
-- Author: Nalfey
-- Version: 1.0

_addon.name = 'PervAlert'
_addon.author = 'Nalfey'
_addon.version = '1.0'
_addon.commands = {'pervalert'}

-- Initialize the addon
function initialize()
    -- Register the incoming text event handler
    local function tohex(str)
        return (str:gsub('.', function(c) return string.format('%02X ', string.byte(c)) end))
    end

    local function clean_name(name)
        -- Remove all non-alphanumeric characters (except hyphens and apostrophes)
        return name:gsub('[^%w%-\']', '')
    end

    windower.register_event('incoming text', function(original, modified, original_mode, modified_mode, blocked)
        -- Only check mode 208 (system message)
        if original_mode == 208 then
            -- Match names with letters, hyphens, apostrophes, and up to 15 chars (FFXI name limit)
            local examiner = original:match('^([^%s]+) examines you%.')
            if examiner then
                local clean = clean_name(examiner)
                coroutine.schedule(function()
                    windower.send_command('input /tell ' .. clean .. ' Stop checking me pervert!')
                end, 3)
            end
        end
    end)
end

-- Handle addon commands
windower.register_event('addon command', function(command, ...)
    if command == 'help' then
        windower.add_to_chat(8, 'PervAlert: Automatically responds to examination messages')
        windower.add_to_chat(8, 'Usage: //pervalert help')
    end
end)

-- Initialize the addon when it's loaded
initialize()
