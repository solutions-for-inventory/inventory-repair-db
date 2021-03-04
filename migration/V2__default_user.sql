INSERT INTO oauth2_client ( id
                          , secret
                          , authorized_grant_types
                          , redirect_uri
                          , access_token_validity
                          , refresh_token_validity
                          , allowed_scope
                          , auto_approve
                          , auth_method
                          , auth_alg
                          , keys_uri
                          , keys
                          , id_token_algs
                          , user_info_algs
                          , request_obj_algs
                          , sector_identifier)
VALUES ( 'app'
       , 'appsecret'
       , '{authorization_code}'
       , '{http://localhost:3000/auth/page/inventoty-auth-provider/callback,http://192.168.0.100:3000/auth/page/inventoty-auth-provider/callback,http://192.168.99.100:3000/auth/page/inventoty-auth-provider/callback}'
       , 3600, 7200, '{openid,profile,address,email}'
       , false, 'client_secret_basic'
       , null
       , null
       , '[]'
       , null
       , null
       , null
       , 'localhost')
ON CONFLICT DO NOTHING;


INSERT INTO t_org_unit ( org_code
                       , name
                       , status
                       , webpage
                       , facebook
                       , locale
                       , created_date
                       , modified_date)
VALUES ( 'XYZK1'
       , 'My company test'
       , 'ENABLED'
       , 'wwww'
       , 'any face'
       , 'es_BO'
       , current_timestamp
       , null)
ON CONFLICT DO NOTHING;

INSERT INTO t_person ( first_name
                     , last_name
                     , document_type
                     , document_id
                     , org_unit_id
                     , created_date
                     , modified_date)
VALUES ( 'Admin'
       , 'Admin'
       , 'NIT'
       , '777'
       , currval('t_org_unit_org_unit_id_seq')
       , current_timestamp
       , null)
ON CONFLICT DO NOTHING;

INSERT INTO t_user ( user_id
                   , username
                   , email
                   , password
                   , status
                   , locale
                   , expiration
                   , new_password_required
                   , created_date
                   , modified_date)
VALUES (currval('t_person_person_id_seq'),
        'admin',
        'admin@dummy.com',
        '$2b$06$nyXH6ETvP3PjcJUbwXLTNuJd6.yS21ovKMNQ9/Z.ZR3w1qLKIlNuC',
        'ACTIVE',
        'es_BO',
        false,
        false,
        current_timestamp,
        null)
ON CONFLICT DO NOTHING;
