

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.groups DISABLE TRIGGER ALL;

INSERT INTO public.groups (id, name) VALUES ('a2c70981-9141-4b9b-be3c-93061a702fe9', 'Home');


ALTER TABLE public.groups ENABLE TRIGGER ALL;


ALTER TABLE public.users DISABLE TRIGGER ALL;

INSERT INTO public.users (id, email, password_hash, locked_at, failed_login_attempts) VALUES ('9119764d-3a53-469b-92c5-28e3a13fb99e', 'jannis@jorre.dev', 'sha256|17|roi5tst5LnnY5ztZzKYmUg==|5LpCyTMjg+cGTFq0Rt4TEE/XPG29jUqg11EsadeOhjU=', NULL, 0);


ALTER TABLE public.users ENABLE TRIGGER ALL;


ALTER TABLE public.group_user_maps DISABLE TRIGGER ALL;



ALTER TABLE public.group_user_maps ENABLE TRIGGER ALL;


ALTER TABLE public.ingredients DISABLE TRIGGER ALL;



ALTER TABLE public.ingredients ENABLE TRIGGER ALL;


