--オッドアイズ・ペンデュラム・ドラゴン
--fixed by MLD
function c511012001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--reduce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16178681,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c511012001.rdcon)
	e2:SetOperation(c511012001.rdop)
	c:RegisterEffect(e2)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c511012001.damcon)
	e4:SetOperation(c511012001.damop)
	c:RegisterEffect(e4)
end
function c511012001.rdcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(511012001)>0 then return false end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return ep==tp and tc and tc:IsType(TYPE_PENDULUM)
end
function c511012001.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(16178681,2)) then
		e:GetHandler():RegisterFlagEffect(511012001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c511012001.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return ep~=tp and bc and bc:IsLevelAbove(5) and bc:IsControler(1-tp)
end
function c511012001.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
