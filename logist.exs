defmodule Logist do
	def lossFunc(m, p), do: [{:v, p[:b] + p[:w1] * m[:x] + p[:w2] * m[:y]}, {:mp, m}, {:pr, p}]
	def mexp(m), do: [{:v, :math.exp(-m[:v])}, {:mp, m[:mp]}, {:pr, m[:pr]}]
	def countUp(m), do:	[{:v, m[:v] + 1}, {:mp, m[:mp]}, {:pr, m[:pr]}] 
	def reciproCal(m), do: [{:v, 1.0 / m[:v]}, {:mp, m[:mp]}, {:pr, m[:pr]}]
	def renewFunc(m), do:	[{:v, (1.0 - m[:mp][:t]) * m[:v] - m[:mp][:t] * (1.0 - m[:v])}, {:mp, m[:mp]}, {:pr, m[:pr]}]
	def dmul(m, a), do: [{:v, m[:v] * a}, {:mp, m[:mp]}, {:pr, m[:pr]}]
	def renewv(m), do: [{:b, m[:v] * 1.0}, {:w1, m[:v] * m[:mp][:x]}, {:w2, m[:v] * m[:mp][:y]}, {:pr, m[:pr]}]
	def vsub(v), do: [{:b, v[:pr][:b] - v[:b]}, {:w1, v[:pr][:w1] - v[:w1]}, {:w2, v[:pr][:w2] - v[:w2]}]

	def calcOnce(mpr, mm, av) do
		mm
		|> lossFunc(mpr)
		|> mexp
		|> countUp
		|> reciproCal
		|> renewFunc
		|> dmul(av)
		|> renewv
		|> vsub
		#|> prPut
	end

	def calcOnces(mpr, mms, av) do
		mpr
		|> calcOnce(mms[:m1], av)
		|> calcOnce(mms[:m2], av)
		|> calcOnce(mms[:m3], av)
		|> calcOnce(mms[:m4], av)
	end

	def recursion(mpr, mms, av, n) do
		if n != 0 do
			mpr
			|> calcOnces(mms, av)
			#|> prPut
			|> recursion(mms, av, n-1)
		else
			mpr
		end
	end

	def prPut(p) do
		IO.puts("#{p[:b]}, #{p[:w1]}, #{p[:w2]}")
		[{:b, p[:b]}, {:w1, p[:w1]}, {:w2, p[:w2]}]
	end
end

m1 = [{:t, 1.0}, {:x, 1.0}, {:y, 4.0}]
m2 = [{:t, 1.0}, {:x, 4.0}, {:y, 6.0}]
m3 = [{:t, 0.0}, {:x, 3.0}, {:y, 2.0}]
m4 = [{:t, 0.0}, {:x, 7.0}, {:y, 3.0}]
mm = [{:m1, m1}, {:m2, m2}, {:m3, m3}, {:m4, m4}]
pr = [{:b, -1.0}, {:w1, 2.0}, {:w2, 3.0}]
alpha = 0.01

Logist.prPut pr

pr = pr
|> Logist.recursion(mm, alpha, 100)

Logist.prPut pr
