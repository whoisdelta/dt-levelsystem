## dt-levelSystem [discord.gg/mdstudios]

## https://imgur.com/inGu9Bs

### Features
- [#] Level up system
- [#] Give XP to players
- [#] Add XP per action

### Installation

Add this to vrp/base.lua

```lua
    exports('link', function()
        return vRP
    end)
```

Add this to your database

```sql
    ALTER TABLE vrp_users ADD COLUMN xp INT DEFAULT 0;
```
