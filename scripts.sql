select  s.period_of_service_id, s.date_start, s.legal_entity_id, s.primary_flag, a.action_code, a.assignment_number
from per_person_names_f n 
join per_periods_of_service s on n.person_id = s.person_id
join per_all_assignments_m a on s.period_of_service_id = a.period_of_service_id
where n.name_type = 'GLOBAL'
and n.last_name = 'Bakynov'
and a.assignment_type = 'E'