--メトロンノーム
--Metrognome
--Scripted by Eerie Code
function c26638543.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26638543,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c26638543.sctg)
	e1:SetOperation(c26638543.scop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26638543.atkcon)
	e2:SetValue(c26638543.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26638543.atkcon)
	c:RegisterEffect(e4)
	-- atk/lv up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26638543,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c26638543.descon)
	e5:SetTarget(c26638543.destg)
	e5:SetOperation(c26638543.desop)
	c:RegisterEffect(e5)
end

function c26638543.scfil(c,h)
	return (c:GetSequence()==6 and c:GetLeftScale()~=h:GetLeftScale()) 
		or (c:GetSequence()==7 and c:GetRightScale()~=h:GetRightScale())
end
function c26638543.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_SZONE) and c26638543.scfil(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c26638543.scfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26638543.scfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c,c)
end
function c26638543.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(pc:GetLeftScale())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(pc:GetRightScale())
		c:RegisterEffect(e2)
	end
end

function c26638543.atkcon(e)
	local tp=e:GetHandlerPlayer()
	local lc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return lc and rc and lc:GetLeftScale()==rc:GetRightScale()
end
function c26638543.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local lc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	return lc:GetLeftScale()*100
end

function c26638543.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c26638543.desfil(c)
	local seq=c:GetSequence()
	return (seq==6 or seq==7) and c:IsDestructable()
end
function c26638543.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c26638543.desfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26638543.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26638543.desfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
