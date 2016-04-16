--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: geom_points_4269; Type: TABLE; Schema: public; Owner: slash; Tablespace: 
--

CREATE TABLE geom_points_4269 (
    gid integer NOT NULL,
    geom geometry,
    CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'POINT'::text) OR (geom IS NULL))),
    CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4269))
);


ALTER TABLE geom_points_4269 OWNER TO slash;

--
-- Name: geom_points_4326; Type: TABLE; Schema: public; Owner: slash; Tablespace: 
--

CREATE TABLE geom_points_4326 (
    gid integer NOT NULL,
    geom geometry,
    CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'POINT'::text) OR (geom IS NULL))),
    CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326))
);


ALTER TABLE geom_points_4326 OWNER TO slash;

--
-- Name: geom_points_4269_pkey; Type: CONSTRAINT; Schema: public; Owner: slash; Tablespace: 
--

ALTER TABLE ONLY geom_points_4269
    ADD CONSTRAINT geom_points_4269_pkey PRIMARY KEY (gid);


--
-- Name: geom_points_4326_pkey; Type: CONSTRAINT; Schema: public; Owner: slash; Tablespace: 
--

ALTER TABLE ONLY geom_points_4326
    ADD CONSTRAINT geom_points_4326_pkey PRIMARY KEY (gid);


--
-- Name: geom_points_4269_geom_index; Type: INDEX; Schema: public; Owner: slash; Tablespace: 
--

CREATE INDEX geom_points_4269_geom_index ON geom_points_4269 USING gist (geom);


--
-- Name: geom_points_4326_geom_index; Type: INDEX; Schema: public; Owner: slash; Tablespace: 
--

CREATE INDEX geom_points_4326_geom_index ON geom_points_4326 USING gist (geom);


--
-- Name: geom_points_4269_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slash
--

ALTER TABLE ONLY geom_points_4269
    ADD CONSTRAINT geom_points_4269_gid_fkey FOREIGN KEY (gid) REFERENCES geom_ids(gid) ON DELETE CASCADE;


--
-- Name: geom_points_4326_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slash
--

ALTER TABLE ONLY geom_points_4326
    ADD CONSTRAINT geom_points_4326_gid_fkey FOREIGN KEY (gid) REFERENCES geom_ids(gid) ON DELETE CASCADE;


--
-- Name: geom_points_4269; Type: ACL; Schema: public; Owner: slash
--

REVOKE ALL ON TABLE geom_points_4269 FROM PUBLIC;
REVOKE ALL ON TABLE geom_points_4269 FROM slash;
GRANT ALL ON TABLE geom_points_4269 TO slash;


--
-- Name: geom_points_4326; Type: ACL; Schema: public; Owner: slash
--

REVOKE ALL ON TABLE geom_points_4326 FROM PUBLIC;
REVOKE ALL ON TABLE geom_points_4326 FROM slash;
GRANT ALL ON TABLE geom_points_4326 TO slash;


--
-- PostgreSQL database dump complete
--

