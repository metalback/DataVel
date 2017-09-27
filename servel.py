#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ConfigParser
import urllib2
import re
import os
import wget

from lxml import objectify
from BeautifulSoup import BeautifulSoup

def get_xml(config):
    XML = open(config.get("servel", "XML_LOCAL_NAME"), 'r')
    XML_CONTENT = XML.read()
    return XML_CONTENT

def get_communes(xml):
    soup = BeautifulSoup(xml)
    communes = soup.findAll({'nomcomuna', 'archcomuna'})
    count = 1
    lista = {}
    for commune in communes:
        if count % 2 != 0 :
            current = commune.text
        else :
            lista[current] = {}
            lista[current]['archivo'] = commune.text
            lista[current]['id_region'] = int(commune.text[1:3])
        count = count+1
    return lista

def get_regions(xml):
    soup = BeautifulSoup(xml)
    regions = soup.findAll('nombre')
    region_dict = {}
    lista = []
    for region in regions:
        lista.append(re.sub(u'^Regi\xf3n [\'de|del\']* ', '', region.text))
    return lista

def get_regions_with_id(xml):
    soup = BeautifulSoup(xml)
    count = 0
    lista = {}

    regions = soup.findAll({'nombre','archcomuna'})
    for data in regions:
        if re.match('^A[0-9]+', data.text) and count % 2 == 0 :
            continue

        count = count + 1

        if count % 2 != 0 :
            current = data.text
        else :
            id_region = int(data.text[1:3])
            lista[id_region] = re.sub(u'^Regi\xf3n [\'de|del\']* ', '', current)
    return lista

def generate_directories(regions, config):
    base_dir = config.get("directory", "BASE")
    
    if not os.path.exists(base_dir):
        os.makedirs(base_dir)

    for region in regions:
        if not os.path.exists(base_dir+'/'+region):
            os.makedirs(base_dir+'/'+region)
    

def get_padron(communes, regions, config):
    base_url = config.get('servel', 'URL_PDF_BASE')
    base_dir = config.get('directory', 'BASE')
    file = open('lista_padron.sh', 'w')
    file.write('#!/bin/bash')
    for commune in communes:
        # print communes[commune]['archivo']
        url_dest = base_dir+'/'+regions[communes[commune]['id_region']]+'/'+commune+'.pdf'
        url_pdf = base_url+communes[commune]['archivo']
        print 'wget --continue '+url_pdf+' -O '+url_dest
        file.write((u'wget --continue '+url_pdf+' -O '+url_dest).encode('utf-8'))
        # wget.download(url_pdf, url_dest, )
    
    

config = ConfigParser.ConfigParser()
config.read("conf.ini")
xml = get_xml(config)
communes = get_communes(xml)
regions = get_regions(xml)
generate_directories(regions, config)
regions = get_regions_with_id(xml)
get_padron(communes, regions, config)