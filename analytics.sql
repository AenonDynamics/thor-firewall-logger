# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# Firewall Log Analytics
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# Views
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

DROP VIEW IF EXISTS `analytics_ports`;
CREATE VIEW `analytics_ports` AS
    SELECT 
        ip_protocol_name, 
        dport, 
        COUNT(*) as num
        
    FROM `log` 
    
    WHERE `timestamp` BETWEEN (NOW() - INTERVAL 14 DAY) AND NOW()
    GROUP BY dport 
    ORDER BY num DESC;


DROP VIEW IF EXISTS `analytics_protocols`;
CREATE VIEW `analytics_protocols` AS
    SELECT 
        ip_protocol_name,
        COUNT(*) as num
        
    FROM `log` 
    
    WHERE `timestamp` BETWEEN (NOW() - INTERVAL 14 DAY) AND NOW()
    GROUP BY ip_protocol 
    ORDER BY num DESC;