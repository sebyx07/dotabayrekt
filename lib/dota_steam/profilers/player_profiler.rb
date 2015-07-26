module DotaSteam
  module Profilers
    module PlayerProfiler
      def role_by_hero(hero_id)
        cache = DotaSteam.configuration.heroes_cache
        cache.get(hero_id)[:role]
      end
    end
  end
end