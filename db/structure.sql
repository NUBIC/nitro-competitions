--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_grants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE access_grants (
    id integer NOT NULL,
    code character varying,
    access_token character varying,
    refresh_token character varying,
    state character varying,
    access_token_expires_at timestamp without time zone,
    person_id integer,
    client_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_grants_id_seq OWNED BY access_grants.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clients (
    id integer NOT NULL,
    name character varying,
    app_id character varying,
    app_secret character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: file_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE file_documents (
    id integer NOT NULL,
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    file_file_name character varying(255),
    file_content_type character varying(255),
    file_file_size integer,
    file_updated_at timestamp without time zone,
    last_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: file_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_documents_id_seq OWNED BY file_documents.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identities (
    id integer NOT NULL,
    user_id integer,
    provider character varying,
    uid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: key_personnel; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE key_personnel (
    id integer NOT NULL,
    submission_id integer,
    user_id integer,
    role character varying(255),
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: key_personnel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE key_personnel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: key_personnel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE key_personnel_id_seq OWNED BY key_personnel.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE logs (
    id integer NOT NULL,
    activity character varying(255),
    user_id integer,
    program_id integer,
    project_id integer,
    controller_name character varying(255),
    action_name character varying(255),
    params text,
    created_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE logs_id_seq OWNED BY logs.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE programs (
    id integer NOT NULL,
    program_name character varying(255),
    program_title character varying(255),
    program_url character varying(255),
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255)
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE programs_id_seq OWNED BY programs.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    program_id integer NOT NULL,
    project_title character varying(255) NOT NULL,
    project_name character varying(255) NOT NULL,
    project_description text,
    project_url character varying(255),
    initiation_date date,
    submission_open_date date,
    submission_close_date date,
    submission_modification_date date,
    review_start_date date,
    review_end_date date,
    project_period_start_date date,
    project_period_end_date date,
    status character varying(255),
    min_budget_request double precision DEFAULT 1000,
    max_budget_request double precision DEFAULT 50000,
    max_assigned_reviewers_per_proposal integer DEFAULT 2,
    max_assigned_proposals_per_reviewer integer DEFAULT 3,
    applicant_wording text DEFAULT 'Principal Investigator'::text,
    applicant_abbreviation_wording text DEFAULT 'PI'::text,
    title_wording text DEFAULT 'Title of Project'::text,
    category_wording text DEFAULT 'Core Facility Name'::text,
    help_document_url_block text DEFAULT '<a href="/docs/Pilot_Proposal_Form.doc" title="Pilot Proposal Form">Application template</a>
<a href="/docs/Application_Instructions.pdf" title="Pilot Proposal Application Instructions">Application instructions</a>
<a href="/docs/Pilot_Budget.doc" title="Pilot Proposal Budget Template">Budget Template</a>
<a href="/docs/Pilot_Budget_Instructions.pdf" title="Pilot Proposal Budget Instructions">Budget instructions</a>'::text,
    rfp_url_block text DEFAULT '<a href="/docs/CTI_RFA.pdf" title="Pilot Proposal Request for Applications">CTI RFA</a>'::text,
    how_to_url_block text DEFAULT '<a href="/docs/NITRO-Competitions_Instructions.pdf" title="NITRO-Competitions Web Site Instructions/Help/HowTo">Site instructions</a>'::text,
    effort_approver_title text DEFAULT 'Effort approver'::text,
    department_administrator_title text DEFAULT 'Financial contact person'::text,
    is_new_wording text DEFAULT 'Is this completely new work?'::text,
    other_funding_sources_wording text DEFAULT 'Other funding sources'::text,
    direct_project_cost_wording text DEFAULT 'Direct project cost'::text,
    show_submission_category boolean DEFAULT false,
    show_core_manager boolean DEFAULT false,
    show_cost_sharing_amount boolean DEFAULT false,
    show_cost_sharing_organization boolean DEFAULT false,
    show_received_previous_support boolean DEFAULT false,
    show_previous_support_description boolean DEFAULT false,
    show_committee_review_approval boolean DEFAULT false,
    show_human_subjects_research boolean DEFAULT false,
    show_irb_approved boolean DEFAULT false,
    show_irb_study_num boolean DEFAULT false,
    show_use_nucats_cru boolean DEFAULT false,
    show_nucats_cru_contact_name boolean DEFAULT false,
    show_use_stem_cells boolean DEFAULT false,
    show_use_embryonic_stem_cells boolean DEFAULT false,
    show_use_vertebrate_animals boolean DEFAULT false,
    show_iacuc_approved boolean DEFAULT false,
    show_iacuc_study_num boolean DEFAULT false,
    show_is_new boolean DEFAULT false,
    show_not_new_explanation boolean DEFAULT false,
    show_use_nmh boolean DEFAULT false,
    show_use_nmff boolean DEFAULT false,
    show_use_va boolean DEFAULT false,
    show_use_ric boolean DEFAULT false,
    show_use_cmh boolean DEFAULT false,
    show_other_funding_sources boolean DEFAULT false,
    show_is_conflict boolean DEFAULT false,
    show_conflict_explanation boolean DEFAULT false,
    show_effort_approver boolean DEFAULT false,
    show_department_administrator boolean DEFAULT false,
    show_budget_form boolean DEFAULT false,
    show_manage_coinvestigators boolean DEFAULT false,
    show_manage_biosketches boolean DEFAULT false,
    require_era_commons_name boolean DEFAULT false,
    review_guidance_url character varying(255) DEFAULT '/docs/review_criteria.html'::character varying,
    overall_impact_title character varying(255) DEFAULT 'Overall Impact'::character varying,
    overall_impact_description text DEFAULT 'Please summarize the strengths and weaknesses of the application; assess the potential benefit of the instrument requested for the overall research community and its potential impact on NIH-funded research; and provide comments on the overall need of the users which led to their final recommendation and level of enthusiasm.'::text,
    overall_impact_direction text DEFAULT 'Overall Strengths and Weaknesses:<br/>Please do not exceed 3 paragraphs'::text,
    show_impact_score boolean DEFAULT true,
    show_team_score boolean DEFAULT true,
    show_innovation_score boolean DEFAULT true,
    show_scope_score boolean DEFAULT true,
    show_environment_score boolean DEFAULT true,
    show_budget_score boolean DEFAULT false,
    show_completion_score boolean DEFAULT false,
    show_other_score boolean DEFAULT false,
    impact_title character varying(255) DEFAULT 'Significance'::character varying,
    impact_wording text DEFAULT 'Does the project address an important unmet health need? If the aims of the project are achieved, how will scientific knowledge, technical capability, and/or clinical practice be improved? How will successful completion of the aims change the methods, technologies, treatments, services, or preventative interventions that drive this field?'::text,
    team_title character varying(255) DEFAULT 'Investigator(s)'::character varying,
    team_wording text DEFAULT 'Are the PIs, collaborators, and other researchers well suited to the project? If Early Stage Investigators or New Investigators, do they have appropriate experience and training? If established, have they demonstrated an ongoing record of accomplishments that have advanced their field(s)? If the project is collaborative, do the investigators have complementary and integrated expertise; are their leadership approach, governance and organizational structure appropriate for the project?'::text,
    innovation_title character varying(255) DEFAULT 'Innovation'::character varying,
    innovation_wording text DEFAULT 'Does the application challenge and seek to shift current clinical practice paradigms by utilizing novel approaches or methodologies, instrumentation, or interventions? Are the approaches or methodologies, instrumentation, or interventions novel to one field of research or novel in a broad sense? Is a refinement, improvement, or new application of approaches or methodologies, instrumentation, or interventions proposed?'::text,
    scope_title character varying(255) DEFAULT 'Approach'::character varying,
    scope_wording text DEFAULT 'Are the overall strategy, methodology, and analyses well-reasoned and appropriate to accomplish the specific aims of the project? Are potential problems, alternative strategies, and benchmarks for success presented? If the project is in the early stages of development, will the strategy establish feasibility and will particularly risky aspects be managed?'::text,
    environment_title character varying(255) DEFAULT 'Environment'::character varying,
    environment_wording text DEFAULT 'Will the scientific environment in which the work will be done contribute to the probability of success? Are the institutional support, equipment and other physical resources available to the investigators adequate for the project proposed? Will the project benefit from unique features of the scientific environment, subject populations, or collaborative arrangements?'::text,
    other_title character varying(255) DEFAULT 'Additional Review Criteria'::character varying,
    other_wording text DEFAULT 'Are the responses to comments from the previous review group adequate? Are the improvements in the resubmission application appropriate? Are there other issues that should be considered when scoring this application?'::text,
    budget_title character varying(255) DEFAULT 'Budget'::character varying,
    budget_wording text DEFAULT 'Is the budget reasonable and appropriate for the request?'::text,
    completion_title character varying(255) DEFAULT 'Completion'::character varying,
    completion_wording text DEFAULT 'Is the project plan laid out so that the majority of the specific aims can be carried out in the specified time? Is there a reasonable expectation that the aims are reasonable and well tied into the objectives and approach?'::text,
    show_abstract_field boolean DEFAULT true,
    abstract_text character varying(255) DEFAULT 'Please include an abstract of your proposal, not to exceed 200 words.'::character varying,
    show_manage_other_support boolean DEFAULT true,
    projects character varying(255) DEFAULT 'Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href=''http://grants.nih.gov/grants/funding/phs398/othersupport.doc''>here</a>.'::character varying,
    manage_other_support_text character varying(255) DEFAULT 'Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href=''http://grants.nih.gov/grants/funding/phs398/othersupport.doc''>here</a>.'::character varying,
    show_document1 boolean DEFAULT false,
    document1_name character varying(255) DEFAULT 'Replace with document name, like ''OSR-1 form'''::character varying,
    document1_description character varying(255) DEFAULT 'Replace with detailed description of the document, the url for a template for the document, etc.'::character varying,
    document1_template_url character varying(255),
    document1_info_url character varying(255),
    project_url_label character varying(255) DEFAULT 'Competition RFA'::character varying,
    application_template_url character varying(255),
    application_template_url_label character varying(255) DEFAULT 'Application template'::character varying,
    application_info_url character varying(255),
    application_info_url_label character varying(255) DEFAULT 'Application instructions'::character varying,
    budget_template_url character varying(255),
    budget_template_url_label character varying(255) DEFAULT 'Budget template'::character varying,
    budget_info_url character varying(255),
    budget_info_url_label character varying(255) DEFAULT 'Budget instructions'::character varying,
    only_allow_pdfs boolean DEFAULT false,
    show_document2 boolean DEFAULT false,
    document2_name character varying(255) DEFAULT 'Replace with document name, like ''OSR-1 form'''::character varying,
    document2_description character varying(255) DEFAULT 'Replace with detailed description of the document, the url for a template for the document, etc.'::character varying,
    document2_template_url character varying(255),
    document2_info_url character varying(255),
    show_document3 boolean DEFAULT false,
    document3_name character varying(255) DEFAULT 'Replace with document name, like ''OSR-1 form'''::character varying,
    document3_description character varying(255) DEFAULT 'Replace with detailed description of the document, the url for a template for the document, etc.'::character varying,
    document3_template_url character varying(255),
    document3_info_url character varying(255),
    show_document4 boolean DEFAULT false,
    document4_name character varying(255) DEFAULT 'Replace with document name, like ''OSR-1 form'''::character varying,
    document4_description character varying(255) DEFAULT 'Replace with detailed description of the document, the url for a template for the document, etc.'::character varying,
    document4_template_url character varying(255),
    document4_info_url character varying(255),
    show_project_cost boolean DEFAULT true,
    show_composite_scores_to_applicants boolean DEFAULT false,
    show_composite_scores_to_reviewers boolean DEFAULT true,
    show_review_summaries_to_applicants boolean DEFAULT true,
    show_review_summaries_to_reviewers boolean DEFAULT true,
    submission_category_description character varying(255) DEFAULT 'Please enter the core you are making this submission for.'::character varying,
    human_subjects_research_text text DEFAULT 'Human subjects research typically includes direct contact with research participants and/or patients. Aggregate data or ''counts'' of patients matching criteria, such as for proposal preparation, it is not typically considered human subjects research.'::text,
    show_application_doc boolean DEFAULT true,
    application_doc_name character varying(255) DEFAULT 'Application'::character varying,
    application_doc_description character varying(255) DEFAULT 'Please upload the completed application here.'::character varying,
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    membership_required boolean DEFAULT false,
    supplemental_document_name character varying(255) DEFAULT 'Supplemental Document (Optional)'::character varying,
    supplemental_document_description character varying(255) DEFAULT 'Please upload any supplemental information here. (Optional)'::character varying,
    closed_status_wording character varying(255) DEFAULT 'Awarded'::character varying,
    show_review_guidance boolean DEFAULT true,
    comment_review_only boolean DEFAULT false,
    custom_review_guidance text
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: reviewers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reviewers (
    id integer NOT NULL,
    program_id integer,
    user_id integer,
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reviewers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviewers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviewers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviewers_id_seq OWNED BY reviewers.id;


--
-- Name: rights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rights (
    id integer NOT NULL,
    name character varying(255),
    controller character varying(255),
    action character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rights_id_seq OWNED BY rights.id;


--
-- Name: rights_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rights_roles (
    right_id integer,
    role_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    id integer NOT NULL,
    role_id integer,
    user_id integer,
    program_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255)
);


--
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_users_id_seq OWNED BY roles_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: submission_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submission_reviews (
    id integer NOT NULL,
    submission_id integer,
    reviewer_id integer,
    review_score double precision,
    review_text text,
    review_doc bytea,
    review_status character varying(255),
    review_completed_at timestamp without time zone,
    innovation_score integer DEFAULT 0,
    impact_score integer DEFAULT 0,
    scope_score integer DEFAULT 0,
    team_score integer DEFAULT 0,
    environment_score integer DEFAULT 0,
    budget_score integer DEFAULT 0,
    completion_score integer DEFAULT 0,
    assigned_at timestamp without time zone,
    accepted_at timestamp without time zone,
    assignment_notification_cnt integer DEFAULT 0,
    assignment_notification_sent_at timestamp without time zone,
    thank_you_sent_at timestamp without time zone,
    assignment_notification_id integer,
    thank_you_sent_id integer,
    innovation_text text,
    impact_text text,
    scope_text text,
    team_text text,
    environment_text text,
    budget_text text,
    overall_score integer DEFAULT 0,
    overall_text text,
    other_score integer DEFAULT 0,
    other_text text,
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: submission_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submission_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submission_reviews_id_seq OWNED BY submission_reviews.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    project_id integer,
    applicant_id integer,
    submission_title character varying(255),
    submission_status character varying(255),
    is_human_subjects_research boolean,
    is_irb_approved boolean,
    irb_study_num character varying(255),
    use_nucats_cru boolean,
    nucats_cru_contact_name character varying(255),
    use_stem_cells boolean,
    use_embryonic_stem_cells boolean,
    use_vertebrate_animals boolean,
    is_iacuc_approved boolean,
    iacuc_study_num character varying(255),
    direct_project_cost double precision,
    is_new boolean,
    use_nmh boolean,
    use_nmff boolean,
    use_va boolean,
    use_ric boolean,
    use_cmh boolean,
    not_new_explanation text,
    other_funding_sources text,
    is_conflict boolean,
    conflict_explanation text,
    effort_approver_ip character varying(255),
    submission_at timestamp without time zone,
    completion_at timestamp without time zone,
    effort_approver_username character varying(255),
    department_administrator_username character varying(255),
    effort_approval_at timestamp without time zone,
    submission_reviews_count integer DEFAULT 0,
    submission_category character varying(255),
    core_manager_username character varying(255),
    cost_sharing_amount double precision,
    cost_sharing_organization text,
    received_previous_support boolean DEFAULT false,
    previous_support_description text,
    committee_review_approval boolean DEFAULT false,
    application_document_id integer,
    budget_document_id integer,
    abstract text,
    other_support_document_id integer,
    document1_id integer,
    document2_id integer,
    document3_id integer,
    document4_id integer,
    applicant_biosketch_document_id integer,
    notification_cnt integer DEFAULT 0,
    notification_sent_at timestamp without time zone,
    notification_sent_by_id integer,
    notification_sent_to character varying(255),
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    supplemental_document_id integer
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    era_commons_name character varying(255),
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    middle_name character varying(255),
    email character varying(255),
    degrees character varying(255),
    name_suffix character varying(255),
    business_phone character varying(255),
    fax character varying(255),
    title character varying(255),
    employee_id integer,
    primary_department character varying(255),
    campus character varying(255),
    campus_address text,
    address text,
    city character varying(255),
    postal_code character varying(255),
    state character varying(255),
    country character varying(255),
    photo_content_type character varying(255),
    photo_file_name character varying(255),
    photo bytea,
    biosketch_document_id integer,
    first_login_at timestamp without time zone,
    last_login_at timestamp without time zone,
    password_salt character varying(255),
    password_hash character varying(255),
    password_changed_at timestamp without time zone,
    password_changed_id integer,
    password_changed_ip character varying(255),
    created_id integer,
    created_ip character varying(255),
    updated_id integer,
    updated_ip character varying(255),
    deleted_at timestamp without time zone,
    deleted_id integer,
    deleted_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notify_on_new_submission boolean DEFAULT true,
    notify_on_complete_submission boolean DEFAULT true,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    oauth_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    object_changes text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_grants ALTER COLUMN id SET DEFAULT nextval('access_grants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_documents ALTER COLUMN id SET DEFAULT nextval('file_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY key_personnel ALTER COLUMN id SET DEFAULT nextval('key_personnel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs ALTER COLUMN id SET DEFAULT nextval('logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY programs ALTER COLUMN id SET DEFAULT nextval('programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviewers ALTER COLUMN id SET DEFAULT nextval('reviewers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rights ALTER COLUMN id SET DEFAULT nextval('rights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users ALTER COLUMN id SET DEFAULT nextval('roles_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submission_reviews ALTER COLUMN id SET DEFAULT nextval('submission_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY access_grants
    ADD CONSTRAINT access_grants_pkey PRIMARY KEY (id);


--
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: file_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY file_documents
    ADD CONSTRAINT file_documents_pkey PRIMARY KEY (id);


--
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: key_personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY key_personnel
    ADD CONSTRAINT key_personnel_pkey PRIMARY KEY (id);


--
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: reviewers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reviewers
    ADD CONSTRAINT reviewers_pkey PRIMARY KEY (id);


--
-- Name: rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rights
    ADD CONSTRAINT rights_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: submission_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submission_reviews
    ADD CONSTRAINT submission_reviews_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_users_on_era_commons_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_era_commons_name ON users USING btree (era_commons_name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20090929015447');

INSERT INTO schema_migrations (version) VALUES ('20090929015448');

INSERT INTO schema_migrations (version) VALUES ('20090929015449');

INSERT INTO schema_migrations (version) VALUES ('20090929015451');

INSERT INTO schema_migrations (version) VALUES ('20090929015454');

INSERT INTO schema_migrations (version) VALUES ('20090930210257');

INSERT INTO schema_migrations (version) VALUES ('20091031200204');

INSERT INTO schema_migrations (version) VALUES ('20091222043643');

INSERT INTO schema_migrations (version) VALUES ('20100526152236');

INSERT INTO schema_migrations (version) VALUES ('20100714211311');

INSERT INTO schema_migrations (version) VALUES ('20140327162328');

INSERT INTO schema_migrations (version) VALUES ('20140418191443');

INSERT INTO schema_migrations (version) VALUES ('20140908190758');

INSERT INTO schema_migrations (version) VALUES ('20141022182109');

INSERT INTO schema_migrations (version) VALUES ('20141031150750');

INSERT INTO schema_migrations (version) VALUES ('20141124223129');

INSERT INTO schema_migrations (version) VALUES ('20141215153829');

INSERT INTO schema_migrations (version) VALUES ('20150102214520');

INSERT INTO schema_migrations (version) VALUES ('20150908211728');

INSERT INTO schema_migrations (version) VALUES ('20150908211820');

INSERT INTO schema_migrations (version) VALUES ('20150908211840');

INSERT INTO schema_migrations (version) VALUES ('20150908211903');

INSERT INTO schema_migrations (version) VALUES ('20150908211927');

INSERT INTO schema_migrations (version) VALUES ('20150908212658');

INSERT INTO schema_migrations (version) VALUES ('20150909163352');

INSERT INTO schema_migrations (version) VALUES ('20150909165240');

INSERT INTO schema_migrations (version) VALUES ('20150909165256');

INSERT INTO schema_migrations (version) VALUES ('20150917161842');

