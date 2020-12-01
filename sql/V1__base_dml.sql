CREATE TYPE client_auth_method AS ENUM ('client_secret_post', 'client_secret_basic', 'client_secret_jwt', 'private_key_jwt', 'none');

create sequence t_org_unit_org_unit_id_seq;
create sequence t_org_user_scope_org_user_scope_id_seq;
create sequence t_role_role_id_seq;
create sequence t_privilege_privilege_id_seq;
create sequence t_user_role_user_role_id_seq;
create sequence t_role_privilege_role_privilege_id_seq;
create sequence t_person_person_id_seq;
create sequence t_address_address_id_seq;
create sequence t_contact_info_contact_info_id_seq;
create sequence t_part_category_part_category_id_seq;
create sequence t_part_part_id_seq;
create sequence t_inventory_inventory_id_seq;
create sequence t_unit_unit_id_seq;
create sequence t_inventory_part_inventory_part_id_seq;
create sequence t_inventory_part_order_inventory_part_order_id_seq;
create sequence t_order_order_id_seq;
create sequence t_sale_sale_id_seq;
create sequence t_sale_detail_sale_detail_id_seq;
create sequence t_payment_payment_id_seq;

CREATE TABLE oauth2_client (
    id text PRIMARY KEY,
    secret text,
    authorized_grant_types text[],
    redirect_uri text[],
    access_token_validity integer NOT NULL,
    refresh_token_validity integer NOT NULL,
    allowed_scope text[],
    auto_approve boolean DEFAULT FALSE,
    auth_method client_auth_method NOT NULL,
    auth_alg text,
    keys_uri text,
    keys jsonb,
    id_token_algs jsonb,
    user_info_algs jsonb,
    request_obj_algs jsonb,
    sector_identifier text NOT NULL
);

CREATE TABLE authz_code (
    code text PRIMARY KEY,
    uid  text NOT NULL,
    client_id text NOT NULL REFERENCES oauth2_client,
    issued_at timestamptz NOT NULL,
    scope text[] NOT NULL,
    nonce text NULL,
    uri   text NULL,
    auth_time timestamptz NOT NULL
);

CREATE TABLE authz_approval (
    uid text,
    client_id text REFERENCES oauth2_client,
    scope text[] NOT NULL,
    denied_scope text[] NOT NULL,
    expires_at timestamptz NOT NULL,
    PRIMARY KEY (uid, client_id)
);

create table t_org_unit (
    org_unit_id   bigint default nextval('t_org_unit_org_unit_id_seq'::regclass) not null constraint t_org_unit_pkey primary key,
    name          varchar                                                        not null,
    org_code      varchar                                                        not null constraint unique_org_unit unique,
    webpage       varchar                                                        not null,
    facebook      varchar                                                        not null,
    status        varchar                                                        not null,
    locale        varchar                                                        not null,
    created_date  timestamp with time zone                                       not null,
    modified_date timestamp with time zone
);

create table t_role (
    role_id       bigint default nextval('t_role_role_id_seq'::regclass)                not null constraint t_role_pkey primary key,
    key           varchar                  not null,
    name          varchar                  not null,
    description   varchar,
    active        boolean                  not null,
    created_date  timestamp with time zone not null,
    modified_date timestamp with time zone
);

create table t_privilege (
    privilege_id  bigint default nextval('t_privilege_privilege_id_seq'::regclass) not null constraint t_privilege_pkey primary key,
    key           varchar                                                          not null,
    name          varchar                                                          not null,
    description   varchar,
    active        boolean                                                          not null,
    created_date  timestamp with time zone                                         not null,
    modified_date timestamp with time zone
);

create table t_role_privilege (
    role_privilege_id bigint default nextval('t_role_privilege_role_privilege_id_seq'::regclass) not null constraint t_role_privilege_pkey primary key,
    role_id           bigint                                                                     not null constraint t_role_privilege_role_id_fkey references t_role,
    privilege_id      bigint                                                                     not null constraint t_role_privilege_privilege_id_fkey references t_privilege (privilege_id)
);

create table t_person (
    person_id     bigint default nextval('t_person_person_id_seq'::regclass) not null constraint t_person_pkey primary key,
    first_name    varchar                                                    not null,
    last_name     varchar                                                    not null,
    document_type varchar                                                    not null,
    document_id   varchar                                                    not null constraint unique_person_document_id unique,
    org_unit_id   bigint                                                     not null constraint t_person_org_unit_id_fkey references t_org_unit,
    created_date  timestamp with time zone                                   not null,
    modified_date timestamp with time zone
);

create table t_user (
    user_id               bigint not null constraint t_user_pkey primary key constraint t_user_person_id_fkey references t_person,
    username              varchar                  not null constraint unique_user_username unique,
    email                 varchar                  not null constraint unique_user_email unique,
    password              varchar                  not null,
    status                varchar                  not null,
    locale                varchar                  not null,
    expiration            boolean                  not null,
    new_password_required boolean                  not null,
    created_date          timestamp with time zone not null,
    modified_date         timestamp with time zone
);

create table t_user_role (
                             user_role_id bigint default nextval('t_user_role_user_role_id_seq'::regclass) not null constraint t_user_role_pkey primary key,
                             user_id      bigint    not null constraint t_user_role_user_id_fkey references t_user,
                             role_id      bigint    not null constraint t_user_role_role_id_fkey references t_role
);

create table t_customer (
    customer_id           bigint not null constraint t_customer_pkey primary key constraint t_customer_person_id_fkey references t_person,
    status                varchar                  not null,
    locale                varchar                  not null,
    created_date          timestamp with time zone not null,
    modified_date         timestamp with time zone
);

create table t_supplier (
                            supplier_id           bigint not null constraint t_supplier_pkey primary key constraint t_supplier_person_id_fkey references t_person,
                            name          varchar                                                        not null,
                            webpage       varchar                                                        not null,
                            org_unit_id   bigint                                                         not null constraint t_supplier_org_unit_id_fkey references t_org_unit,
                            created_date  timestamp with time zone                                       not null,
                            modified_date timestamp with time zone
);

create table t_org_user_scope (
    org_user_scope_id bigint default nextval('t_org_user_scope_org_user_scope_id_seq'::regclass) not null constraint t_org_user_scope_pkey primary key,
    user_id           bigint    not null constraint t_org_user_scope_user_id_fkey references t_user,
    org_unit_id       bigint    not null constraint t_org_user_scope_org_unit_id_fkey references t_org_unit
);

create table t_address (
    address_id    bigint default nextval('t_address_address_id_seq'::regclass) not null constraint t_address_pkey primary key,
    street1       varchar                                                      not null,
    street2       varchar                                                      not null,
    street3       varchar                                                      not null,
    zip           varchar                                                      not null,
    city          varchar                                                      not null,
    state         varchar                                                      not null,
    country       varchar                                                      not null,
    person_id     bigint not null constraint unique_address_person_id unique constraint t_address_person_id_fkey references t_person,
    created_date  timestamp with time zone                                     not null,
    modified_date timestamp with time zone
);

create table t_contact_info (
    contact_info_id bigint default nextval('t_contact_info_contact_info_id_seq'::regclass) not null constraint t_contact_info_pkey primary key,
    contact_type    varchar                                                                not null,
    contact         varchar                                                                not null,
    person_id       bigint                                                                 not null constraint t_contact_info_person_id_fkey references t_person,
    created_date    timestamp with time zone                                               not null,
    modified_date   timestamp with time zone
);

create table t_part_category (
    part_category_id   bigint default nextval('t_part_category_part_category_id_seq'::regclass) not null constraint t_part_category_pkey primary key,
    name          varchar                                                        not null,
    key           varchar,
    description   varchar                                                        not null,
    parent_category_id bigint constraint t_part_category_part_category_id_fkey references t_part_category,
    created_date  timestamp with time zone                                       not null,
    modified_date timestamp with time zone
);

create table t_inventory (
    inventory_id          bigint default nextval('t_inventory_inventory_id_seq'::regclass) not null constraint t_inventory_pkey primary key,
    name                  varchar                                                          not null constraint unique_inventory_name unique,
    description           varchar                                                          not null,
    status                varchar                                                          not null,
    allow_negative_stocks boolean                                                          not null,
    org_unit_id           bigint                                                           not null constraint t_inventory_org_unit_id_fkey references t_org_unit,
    created_date          timestamp with time zone                                         not null,
    modified_date         timestamp with time zone
);

create table t_unit (
    unit_id       bigint default nextval('t_unit_unit_id_seq'::regclass) not null constraint t_unit_pkey primary key,
    key           varchar                                                not null,
    label         varchar                                                not null,
    created_date  timestamp with time zone                               not null,
    modified_date timestamp with time zone
);

create table t_part (
    part_id       bigint default nextval('t_part_part_id_seq'::regclass) not null constraint t_part_pkey primary key,
    part_number   varchar,
    name          varchar                                                not null,
    default_price double precision                                       not null,
    description   varchar,
    images        varchar                                                not null,
    manufacturer  varchar,
    model         varchar,
    notes         varchar,
    status        varchar                                                not null,
    parent_part_id bigint constraint t_part_parent_part_id_fkey references t_part,
    part_category_id   bigint constraint t_part_part_category_id_fkey references t_part_category,
    unit_id       bigint constraint t_part_unit_id_fkey references t_unit,
    org_unit_id   bigint                                                 not null constraint t_part_org_unit_id_fkey references t_org_unit,
    created_date  timestamp with time zone                               not null,
    modified_date timestamp with time zone
);

create table t_inventory_part (
    inventory_part_id bigint default nextval('t_inventory_part_inventory_part_id_seq'::regclass) not null constraint t_inventory_part_pkey primary key,
    code              varchar                                                                    not null,
    status            varchar                                                                    not null,
    level             bigint                                                                     not null,
    max_level_allowed bigint                                                                     not null,
    min_level_allowed bigint                                                                     not null,
    price             double precision                                                           not null,
    location          varchar                                                                    not null,
    date_expiry       timestamp with time zone,
    part_id           bigint                                                                     not null constraint t_inventory_part_part_id_fkey references t_part,
    inventory_id      bigint                                                                     not null constraint t_inventory_part_inventory_id_fkey references t_inventory,
    created_date      timestamp with time zone                                                   not null,
    modified_date     timestamp with time zone
);

create table t_order (
    order_id            bigint default nextval('t_order_order_id_seq'::regclass) not null constraint t_order_pkey primary key,
    discount            double precision                                         not null,
    order_date          timestamp with time zone                                 not null,
    delivered_lead_time timestamp with time zone                                 not null,
    status              varchar                                                  not null,
    notes               varchar                                                  not null,
    inventory_id        bigint                                                   not null constraint t_order_inventory_id_fkey references t_inventory,
    supplier_id         bigint                                                   not null constraint t_order_supplier_id_fkey references t_supplier,
    emitter_id          bigint                                                   not null constraint t_order_emitter_id_fkey references t_user,
    org_unit_id         bigint                                                   not null constraint t_order_org_unit_id_fkey references t_org_unit,
    created_date        timestamp with time zone                                 not null,
    modified_date       timestamp with time zone
);

create table t_inventory_part_order (
    inventory_part_order_id bigint default nextval('t_inventory_part_order_inventory_part_order_id_seq'::regclass) not null constraint t_inventory_part_order_pkey primary key,
    quantity                bigint                                          not null,
    price                   double precision                                not null,
    discount                double precision                                not null,
    sub_total_price         double precision                                not null,
    notes                   varchar                                         not null,
    inventory_part_id       bigint                                          not null constraint t_inventory_part_order_inventory_part_id_fkey references t_inventory_part,
    order_id                 bigint                                          not null constraint t_inventory_part_order_order_id_fkey references t_order,
    created_date            timestamp with time zone                        not null,
    modified_date           timestamp with time zone
);

create table t_payment (
    payment_id          bigint default nextval('t_payment_payment_id_seq'::regclass) not null constraint t_payment_pkey primary key,
    paymentMode         varchar                                                  not null,
    paymentStatus       varchar                                                  not null,
    paymentGross        double precision                                         not null,
    paymentBilled       double precision                                         not null,
    paymentFee          double precision                                         not null,
    paymentDate         timestamp with time zone                                 not null,
    transactionId       varchar                                                  not null,
    currency            varchar                                                  not null,
    comments            varchar,
    paymentErrorCode    varchar                                                  not null,
    paymentErrorMessage varchar                                                  not null,
    taken_by_id         bigint                                                   not null constraint t_payment_taken_by_id_fkey references t_user,
    org_unit_id         bigint                                                   not null constraint t_payment_org_unit_id_fkey references t_org_unit,
    created_date        timestamp with time zone                                 not null,
    modified_date       timestamp with time zone
);

create table t_sale (
    sale_id            bigint default nextval('t_sale_sale_id_seq'::regclass) not null constraint t_sale_pkey primary key,
    discount           double precision                                         not null,
    sale_date          timestamp with time zone                                  not null,
    status             varchar                                                  not null,
    notes              varchar                                                  not null,
    sale_agent_id      bigint                                                   not null constraint t_sale_sale_agent_id_fkey references t_user,
    customer_id        bigint                                                   not null constraint t_sale_customer_id_fkey references t_customer,
    org_unit_id        bigint                                                   not null constraint t_sale_org_unit_id_fkey references t_org_unit,
    payment_id         bigint                                                   not null constraint t_sale_payment_id_fkey references t_payment,
    created_date       timestamp with time zone                                 not null,
    modified_date      timestamp with time zone
);

create table t_sale_detail (
    t_sale_detail_id bigint default nextval('t_sale_detail_sale_detail_id_seq'::regclass) not null constraint t_sale_detail_pkey primary key,
    quantity                bigint                                          not null,
    price                   double precision                                not null,
    discount                double precision                                not null,
    part_id                 bigint                                          not null constraint t_sale_detail_part_id_fkey references t_part,
    sale_id                 bigint                                          not null constraint t_sale_detail_sale_id_fkey references t_sale,
    created_date            timestamp with time zone                        not null,
    modified_date           timestamp with time zone
);

