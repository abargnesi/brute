require 'open3'
require 'tempfile'

module Brute
  class Command

    BEL_FILE    = 'ortho_test.bel'
    COMPILER    = [
      './belc.sh', '-v', '-t', '-k', 'test', '-d', 'test', '--no-preserve'
    ]
    ORTHOLOGIZE = [
      './tools/Orthologize.sh', '-v', '-t', '9606', 'test'
    ]
    ORTHOLOGY_STATEMENTS = [
      'complex(p(HGNC:EGFR),p(HGNC:ERBB3)) orthologous complex(p(MGI:Egfr),p(MGI:Erbb3))',
      'complex(p(HGNC:EGFR),p(HGNC:ERBB3)) orthologous complex(p(RGD:Egfr),p(RGD:Erbb3))',
      'complex(p(MGI:Egfr),p(MGI:Erbb3)) orthologous complex(p(RGD:Egfr),p(RGD:Erbb3))',
      'complex(p(HGNC:ERBB3),p(HGNC:ERBB2)) orthologous complex(p(MGI:Erbb3),p(MGI:Erbb2))',
      'complex(p(HGNC:ERBB3),p(HGNC:ERBB2)) orthologous complex(p(RGD:Erbb3),p(RGD:Erbb2))',
      'complex(p(MGI:Erbb3),p(MGI:Erbb2)) orthologous complex(p(RGD:Erbb3),p(RGD:Erbb2))',
      'complex(p(HGNC:ERBB3),p(HGNC:PIK3R2)) orthologous complex(p(MGI:Erbb3),p(MGI:Pik3r2))',
      'complex(p(HGNC:ERBB3),p(HGNC:PIK3R2)) orthologous complex(p(RGD:Erbb3),p(RGD:Pik3r2))',
      'complex(p(MGI:Erbb3),p(MGI:Pik3r2)) orthologous complex(p(RGD:Erbb3),p(RGD:Pik3r2))',
      'p(HGNC:ERBB3,pmod(P,Y,1289)) orthologous p(HGNC:Erbb3,pmod(P,Y,1286))',
      'p(HGNC:ERBB3,pmod(P,Y,1289)) orthologous p(RGD:Erbb3,pmod(P,Y,1286))'
    ]

    def initialize
      @count = 0
    end

    def run_command
      output = ''
      exit_code = 0

      bel_file = create_temp_bel_file

      output_compiler, status = Open3.capture2e(*(COMPILER + ['-f', bel_file.path]))
      output.concat(output_compiler)
      exit_code ||= status.exitstatus

      puts "Compiler finished, exit code: #{exit_code}"
      puts output_compiler

      if exit_code.zero?
        output_orthologize, status = Open3.capture2e(*ORTHOLOGIZE)
        output.concat(output_orthologize)
        exit_code ||= status.exitstatus

        puts "Orthologize finished, exit code: #{exit_code}"
        puts output_orthologize
      end

      {
        :output    => output,
        :exit_code => exit_code
      }
    end

    def mutate
      @count += 1
    end

    private

    def create_temp_bel_file
      temp_bel = Tempfile.new(['beltest', '.bel'], :encoding => 'UTF-8')

      puts "Adding #{@count} orthology statements:"
      ORTHOLOGY_STATEMENTS.slice(0, @count).each do |line|
        puts "  #{line}"
      end

      orthology = ORTHOLOGY_STATEMENTS.slice(0, @count).join("\n")
      File.write(temp_bel, File.read(BEL_FILE) + orthology)

      temp_bel.flush
      temp_bel
    end
  end
end
