defmodule Productive.Step do

  defmacro __using__( opts ) do
    quote do

      import Productive.Step.Utils

      @any "any"
      @logger unquote(opts[:logger])

      def call( product, opts \\ [] ) do
        log_step __MODULE__, product, opts

        product
        |> do_prepare( opts )
        |> do_work( product, opts )
      end

      def do_prepare( product, opts \\ [] ) do
        prepare( product, opts )
      end

      # Private ##########

      defp do_work( state, product, opts \\ [] ) do
        state_info( inspect( state ), opts)

        work( state, product, opts )
      end

      def prepare( _recipe, _opts ), do: @any

      defp work( _state, _product, _opts ), do: raise("You must implement the work function(s)")

      defp log_step( module, product \\ %{}, opts \\ [] ) do
        step_name = inspect( __MODULE__ )

        step_info step_name, opts
      end

      defp debug(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :debug, [msg])
      end

      defp info(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :info, [msg])
      end

      defp error(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :error, [msg])
      end

      defp warn(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :warn, [msg])
      end

      defp step_info(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :step_info, [msg])
      end

      defp state_info(msg, opts \\ []) do
        logger = Keyword.get(opts, :logger, @logger)

        apply(logger, :state_info, [msg])
      end

      defoverridable [
        log_step: 1,
        log_step: 2,
        log_step: 3,
        prepare: 2,
        work: 3
      ]

    end
  end

end
