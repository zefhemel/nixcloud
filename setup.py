from distutils.core import setup
import glob

setup(name='nixcloud',
      version='0.1',
      description='NixCloud PaaS',
      url='https://github.com/zefhemel/nixcloud',
      author='Zef Hemel',
      author_email='zef.hemel@logicblox.com',
      scripts=['bin/nixcloud-git-receive',
               'bin/nixcloud-deploy'],
      packages=['nixcloud']
      )
