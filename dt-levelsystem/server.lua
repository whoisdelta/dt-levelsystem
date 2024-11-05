local vRP = exports["vrp"]:link();

local userLevel = {};

RegisterServerEvent('lvl:giveXp');

local giveXp = function(src, xp)
    local user_id = vRP.getUserId(src);

    if not userLevel[user_id] then
        userLevel[user_id] = 0;
    end

    userLevel[user_id] = userLevel[user_id] + xp;

    TriggerClientEvent('sendNUIMessage', src , {
        interface = 'lvl',
        action = 'lvlup',
        xp = userLevel[user_id]
    });
end AddEventHandler('lvl:giveXp', giveXp);

RegisterCommand('givexp', function(source, args)
    local _src = source;
    local user_id = vRP.getUserId(_src);
    local targetId = tonumber(args[1]);
    local xp = tonumber(args[2]) or 0;

    if not vRP.isAdmin(user_id) then
        return;
    end

    if not xp or not targetId then
        TriggerClientEvent('chatMessage', source, 'syntax: /givexp <id> <xp>');
        return;
    end

    local targetSource = vRP.getUserSource(targetId);

    if not targetSource then
        TriggerClientEvent('chatMessage', source, 'Jucatorul nu este online');
        return;
    end

    giveXp(targetSource, xp);
end)

exports('giveXp', giveXp);

exports('getUserLevel', function(user_id)
    return (userLevel[user_id]/25) > 0 and (userLevel[user_id]/25) or 0;
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source,fs)
    if not fs then return end;

    local userData = exports['oxmysql']:querySync('SELECT * FROM vrp_users WHERE id = ?', {user_id})[1];

    if userData.xp then
        userLevel[user_id] = userData.xp;
    else
        userLevel[user_id] = 0;
    end

end)

AddEventHandler("vRP:playerLeave", function(user_id, source)
    exports['oxmysql']:execute('UPDATE vrp_users SET xp = ? WHERE id = ?', {userLevel[user_id], user_id});
end)
