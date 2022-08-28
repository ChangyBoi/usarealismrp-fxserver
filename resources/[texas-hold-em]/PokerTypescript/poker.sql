CREATE TABLE IF NOT EXISTS `poker_players` (
  `uniqueId` varchar(512) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `stat_betchips` int(11) DEFAULT 0,
  `stat_wonchips` int(11) DEFAULT 0,
  `stat_played` int(11) DEFAULT 0,
  `stat_wongames` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;