ALTER TABLE `redmine`.`time_entries` 
ADD COLUMN `audit_id` INT(11) NULL AFTER `updated_on`,
ADD COLUMN `audit_name` VARCHAR(45) NULL AFTER `audit_id`,
ADD COLUMN `time_type` VARCHAR(45) NULL AFTER `audit_name`,
ADD COLUMN `time_typename` VARCHAR(45) NULL AFTER `time_type`,
ADD COLUMN `audit_hours` VARCHAR(45) NULL AFTER `time_typename`;

ALTER TABLE `redmine`.`time_entries` 
ADD COLUMN `audit_status` VARCHAR(45) NULL AFTER `audit_hours`;